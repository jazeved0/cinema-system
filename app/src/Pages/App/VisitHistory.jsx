import React, { useRef } from "react";
import { useAuthGet } from "Api";
import { useNotifications } from "Notifications";

import { AppBase } from "Pages";
import { DataGrid } from "Components";
import {
  AddressFormatter,
  PopoverFilter,
  ComboFilter
} from "Components/DataGrid";

export default function VisitHistory() {
  // Fetch visits from API
  const { toast } = useNotifications();
  const [{ visits }, { isLoading }] = useAuthGet({
    route: "/visits",
    defaultValue: { visits: [] },
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

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "theatername",
      name: "Theater"
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
    },
    {
      key: "date",
      name: "Visit Date",
      filterRenderer: PopoverFilter,
      popoverFilter: PopoverFilter.Date
    }
  ].map(c => ({ ...baseColumn, ...c }));

  return (
    <AppBase title="Visit History" level="user">
      <DataGrid
        isLoading={isLoading}
        data={visits}
        columns={columns}
        canDeleteRow={() => false}
        columnWidths={{
          base: [180, 300, 220, 200],
          "992": [180, 300, 220, 190],
          "1200": [230, 340, 260, null]
        }}
      />
    </AppBase>
  );
}
VisitHistory.displayName = "VisitHistory";
