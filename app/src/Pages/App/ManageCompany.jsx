import React, { useRef, useMemo } from "react";
import { useAuthGet } from "Api";
import { isDefined } from "Utility";

import { AppBase } from "Pages";
import { DataGrid, Icon } from "Components";
import { NumericFilter, ComboFilter } from "Components/DataGrid";

export default function ManageCompany() {
  // Fetch API data
  let [companies, isLoading] = useAuthGet("/companies", {
    config: { params: { only_names: false } }
  });
  companies = isDefined(companies) ? companies : [];

  // Use ref to bypass incorrect generation usage
  const companyNameRef = useRef([]);
  companyNameRef.current = useMemo(() => companies.map(c => c.name), [
    companies
  ]);

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "name",
      name: "Name",
      filterRenderer: props => (
        <ComboFilter options={companyNameRef.current} {...props} />
      )
    },
    {
      key: "numcitycover",
      name: "# Cities Covered",
      filterRenderer: NumericFilter
    },
    {
      key: "numtheater",
      name: "# Theaters",
      filterRenderer: NumericFilter
    },
    {
      key: "numemployee",
      name: "# Employees",
      filterRenderer: NumericFilter
    }
  ].map(c => ({ ...baseColumn, ...c }));

  // Details callback
  const showDetails = row => {
    console.log("showing details");
    console.log(row);
  };

  return (
    <AppBase title="Manage Company" level="admin">
      <DataGrid
        data={companies}
        columns={columns}
        columnWidths={{
          base: [300, 190, 190, 190],
          "992": [null, 190, 190, 190]
        }}
        isLoading={isLoading}
        canDeleteRow={() => false}
        getRowActions={row => {
          if (isLoading) return [];
          else
            return [
              {
                icon: <Icon name="info-circle" size="lg" noAutoWidth />,
                callback: () => showDetails(row)
              }
            ];
        }}
      />
    </AppBase>
  );
}
ManageCompany.displayName = "ManageCompany";
