import React, { useRef, useMemo } from "react";
import { isDefined } from "Utility";
import { useAuthGet } from "Api";
import { useRouteMatch, useHistory, Redirect } from "react-router-dom";

import { AppBase, CompanyDetail } from "Pages";
import { Modal } from "react-bootstrap";
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

  // Details
  const base = "/app/admin/manage-company";
  const detailsRouteMatch = useRouteMatch({ path: `${base}/details/:name` });
  const detailShown = isDefined(detailsRouteMatch);
  const history = useHistory();
  const hideDetails = () => history.push(base);
  const showDetails = ({ name }) =>
    history.push(`${base}/details/${encodeURI(name)}`);
  const detailCompany = detailShown
    ? decodeURI(detailsRouteMatch.params.name)
    : null;

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
      <Redirect from={`${base}/details`} to={base} exact />
      <Modal
        show={detailShown}
        onHide={hideDetails}
        dialogClassName="company-details"
      >
        <Modal.Header closeButton />
        <div className="content">
          <CompanyDetail company={detailCompany} />
        </div>
      </Modal>
    </AppBase>
  );
}
ManageCompany.displayName = "ManageCompany";
