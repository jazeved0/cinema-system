import React, { useRef, useMemo } from "react";
import { useAuthGet } from "Api";
import { useNotifications } from "Notifications";

import { AppBase } from "Pages";
import { DataGrid } from "Components";
import {
  AddressFormatter,
  PopoverFilter,
  ComboFilter
} from "Components/DataGrid";

export default function ExploreTheater() {
  // Fetch visits from API
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

  return (
    <AppBase title="Explore Theater" level="user">
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
      />
    </AppBase>
  );
}
ExploreTheater.displayName = "ExploreTheater";
