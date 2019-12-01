import React, { useRef } from "react";
import { useAuthGet } from "Api";
import { useNotifications } from "Notifications";
import { processCreditCardInput } from "Utility";

import { AppBase } from "Pages";
import { DataGrid } from "Components";
import {
  ComboFilter,
  PopoverFilter,
  CreditCardFormatter
} from "Components/DataGrid";

export default function ViewHistory() {
  // Fetch views from API
  const { toast } = useNotifications();
  const [{ views }, { isLoading }] = useAuthGet({
    route: "/movies/views",
    defaultValue: { views: [] },
    onFailure: toast
  });

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "moviename",
      name: "Movie"
    },
    {
      key: "theatername",
      name: "Theater"
    },
    {
      key: "companyname",
      name: "Company",
      optionsGetter: () => companyNameRef.current,
      filterRenderer: ComboFilter
    },
    {
      key: "creditcardnum",
      name: "Credit Card",
      formatter: CreditCardFormatter,
      processValue: processCreditCardInput
    },
    {
      key: "playdate",
      name: "View Date",
      filterRenderer: PopoverFilter,
      popoverFilter: PopoverFilter.Date
    }
  ].map(c => ({ ...baseColumn, ...c }));

  // Fetch company names
  let [{ companies }] = useAuthGet({
    route: "/companies",
    config: { params: { only_names: true } },
    defaultValue: { companies: [] }
  });

  // Use refs to bypass incorrect filter generation usage
  const companyNameRef = useRef([]);
  companyNameRef.current = companies;

  return (
    <AppBase title="View History" level="customer">
      <DataGrid
        isLoading={isLoading}
        data={views}
        columns={columns}
        canDeleteRow={() => false}
        columnWidths={{
          base: [180, 160, 180, 220, 200],
          "992": [180, 130, 180, 220, 190],
          "1200": [230, 130, 200, 260, null]
        }}
      />
    </AppBase>
  );
}
ViewHistory.displayName = "ViewHistory";
