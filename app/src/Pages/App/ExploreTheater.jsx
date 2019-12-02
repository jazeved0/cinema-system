import React, { useRef, useMemo, useCallback, useState } from "react";
import { useAuthGet, performAuthRequest } from "Api";
import { useAuth } from "Authentication";
import { useNotifications } from "Notifications";
import {
  identity,
  isNil,
  useCallbackOnce,
  isDefined,
  formatDate
} from "Utility";

import { AppBase } from "Pages";
import { Form as BootstrapForm } from "react-bootstrap";
import { DataGrid, Icon, Form } from "Components";
import {
  AddressFormatter,
  PopoverFilter,
  ComboFilter
} from "Components/DataGrid";

export default function ExploreTheater() {
  // Fetch theaters from API
  const { toast } = useNotifications();
  const [{ theaters }, { isLoading }] = useAuthGet({
    route: "/theaters",
    defaultValue: { theaters: [] },
    onFailure: toast
  });

  // Fetch company names
  let [{ companies }] = useAuthGet({
    route: "/companies",
    config: { params: { only_names: true } },
    defaultValue: { companies: [] }
  });

  // Use refs to bypass incorrect filter generation usage
  const companyNameRef = useRef([]);
  companyNameRef.current = companies;
  const theaterNameRef = useRef([]);
  theaterNameRef.current = useMemo(
    () => Array.from(new Set(theaters.map(({ theatername }) => theatername))),
    [theaters]
  );

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "theatername",
      name: "Theater",
      optionsGetter: () => theaterNameRef.current,
      filterRenderer: ComboFilter
    },
    {
      key: "street",
      name: "Address",
      formatter: AddressFormatter,
      filterRenderer: PopoverFilter,
      popoverFilter: PopoverFilter.Address
    },
    {
      key: "companyname",
      name: "Company",
      optionsGetter: () => companyNameRef.current,
      filterRenderer: ComboFilter
    }
  ].map(c => ({ ...baseColumn, ...c }));

  // Visit date entering box
  const [visitDate, setVisitDate] = useState(null);
  const [showValidation, setShowValidation] = useState(false);
  const onChangeVisitDate = useCallbackOnce((_, e) => {
    if (isDefined(e)) setShowValidation(false);
    setVisitDate(e);
  });
  const visitDateRef = useRef([]);
  visitDateRef.current = visitDate;

  // Visit callback
  const { token } = useAuth();
  const visit = useCallback(
    theater => {
      if (isNil(visitDateRef.current)) {
        setShowValidation(true);
        return;
      }

      // Send API request
      const visitDate = visitDateRef.current;
      performAuthRequest("/visits", "post", token, {
        config: {
          data: {
            date: formatDate(visitDate),
            theatername: theater.theatername,
            companyname: theater.companyname
          }
        },
        onSuccess: () =>
          toast(
            `Theater ${theater.theatername} successfully visited on ${formatDate(
              visitDate
            )}`,
            "success"
          ),
        onFailure: toast,
        retry: false
      });
    },
    [toast, token]
  );

  return (
    <AppBase title="Explore Theater" level="user">
      <div className="explore-theater__visit-date">
        <BootstrapForm.Group>
          <BootstrapForm.Label>Visit Date:</BootstrapForm.Label>
          <Form.Input
            type="date"
            inputKey={null}
            placeholder={"Select visit date"}
            onChange={onChangeVisitDate}
            value={visitDate}
            onBlur={identity}
            onKeyDown={identity}
            isInvalid={showValidation}
            message="A visit date must be selected before visiting any theater"
          />
        </BootstrapForm.Group>
      </div>
      <DataGrid
        isLoading={isLoading}
        data={theaters}
        columns={columns}
        canDeleteRow={() => false}
        columnWidths={{
          base: [180, 300, 220],
          "992": [200, 300, 250],
          "1200": [270, null, 320]
        }}
        getRowActions={row => {
          if (isLoading) return [];
          else
            return [
              {
                icon: <Icon name="scroll" size="lg" noAutoWidth />,
                callback: () => visit(row)
              }
            ];
        }}
      />
    </AppBase>
  );
}
ExploreTheater.displayName = "ExploreTheater";
