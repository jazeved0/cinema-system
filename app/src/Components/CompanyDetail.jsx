import React, { useMemo } from "react";
import { useAuthGet } from "Api";
import { useNotifications } from "Notifications";
import { isDefined } from "Utility";

import { Placeholder, DataGrid } from "Components";
import { NumericFilter } from "Components/DataGrid";

export default function CompanyDetail({ company }) {
  const { toast } = useNotifications();

  // Get employees via API request
  const [{ managers: employees }] = useAuthGet(
    {
      route: `/companies/${encodeURI(company)}/managers`,
      onFailure: toast,
      defaultValue: { managers: [] }
    },
    [company]
  );
  const employeesText = useMemo(
    () =>
      isDefined(employees)
        ? employees.map(e => `${e.firstname} ${e.lastname}`).join(", ")
        : employees,
    [employees]
  );

  // Get theaters via API request
  const [{ theaters }, { isLoading: theatersLoading }] = useAuthGet(
    {
      route: `/companies/${encodeURI(company)}/theaters`,
      onFailure: toast,
      defaultValue: { theaters: [] }
    },
    [company]
  );

  // Add manager names to theater lines
  const derivedTheaters = useMemo(() => {
    if (employees.length === 0) return theaters;
    return theaters.map(t => {
      const { manager } = t;
      const managerEntity = employees.find(e => e.username === manager);
      if (isDefined(managerEntity)) {
        return {
          ...t,
          manager: `${managerEntity.firstname} ${managerEntity.lastname}`
        };
      } else return t;
    });
  }, [theaters, employees]);

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "theatername",
      name: "Name"
    },
    {
      key: "manager",
      name: "Manager"
    },
    {
      key: "city",
      name: "City"
    },
    {
      key: "state",
      name: "State"
    },
    {
      key: "capacity",
      name: "Capacity",
      filterRenderer: NumericFilter
    }
  ].map(c => ({ ...baseColumn, ...c }));

  return (
    <div className="company-detail">
      <h2>Company Detail</h2>
      <div className="company-detail__row">
        <span className="company-detail__row-label">Name:</span>
        <span className="company-detail__row-value">{company}</span>
      </div>
      <div className="company-detail__row">
        <span className="company-detail__row-label">Employees:</span>
        <span className="company-detail__row-value">
          <Placeholder.Text auto inline text={employeesText} width={240} />
        </span>
      </div>
      <div className="company-detail__theaters">
        <h4>Theaters</h4>
        <DataGrid
          isLoading={theatersLoading}
          data={derivedTheaters}
          columns={columns}
          canDeleteRow={() => false}
          columnWidths={{
            base: [200, 160, 100, 60, 60],
            "992": [null, 260, 120, 100, 100]
          }}
        />
      </div>
    </div>
  );
}

CompanyDetail.displayName = "CompanyDetail";
