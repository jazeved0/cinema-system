import React, { useRef, useMemo, useCallback } from "react";
import { isDefined, useCallbackOnce } from "Utility";
import { useAuthGet } from "Api";
import { useRouteMatch, useHistory } from "react-router-dom";

import { AppBase } from "Pages";
import { Modal, Button } from "react-bootstrap";
import { DataGrid, Icon, CompanyDetail, CreateTheaterForm } from "Components";
import { NumericFilter, ComboFilter } from "Components/DataGrid";

export default function ManageCompany() {
  // Fetch API data
  let [{ companies }, { isLoading, refresh }] = useAuthGet({
    route: "/companies",
    config: { params: { only_names: false } },
    defaultValue: { companies: [] }
  });

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

  // Create theater dialog visibility
  const dialogPath = `${base}/create-theater`;
  const createTheaterDialogShown = isDefined(
    useRouteMatch({ path: dialogPath })
  );
  const hideCreateTheaterDialog = useCallbackOnce(() => history.push(base));
  const showCreateTheaterDialog = useCallbackOnce(() =>
    history.push(dialogPath)
  );

  // Update local cache upon theater add
  const createTheater = useCallback(() => {
    refresh();
    hideCreateTheaterDialog();
  }, [hideCreateTheaterDialog, refresh]);

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
        toolbarComponents={
          <Button
            variant="primary"
            className="create-theater-button"
            onClick={showCreateTheaterDialog}
          >
            Create Theater
          </Button>
        }
      />
      <Modal
        show={detailShown}
        onHide={hideDetails}
        dialogClassName="company-details modal-container modal-app"
      >
        <Modal.Header closeButton />
        <div className="content">
          <CompanyDetail company={detailCompany} />
        </div>
      </Modal>
      <Modal
        show={createTheaterDialogShown}
        onHide={hideCreateTheaterDialog}
        dialogClassName="company-details modal-app"
        size="lg"
      >
        <Modal.Header closeButton />
        <div className="content create-theater">
          <h2>Create Theater</h2>
          <CreateTheaterForm
            show={createTheaterDialogShown}
            onHide={hideCreateTheaterDialog}
            onAdd={createTheater}
          />
        </div>
      </Modal>
    </AppBase>
  );
}
ManageCompany.displayName = "ManageCompany";
