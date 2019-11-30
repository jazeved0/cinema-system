import React, { useState, useCallback, useMemo } from "react";
import { useAuthGet } from "Api";
import { useNotifications } from "Notifications";
import { isNil } from "Utility";

import { DataGrid, Switch } from "Components";
import { NumericFilter, DateFilter } from "Components/DataGrid";
import { AppBase } from "Pages";

export default function TheaterOverview() {
  const { toast } = useNotifications();

  // Get movies via API request
  const [{ movies }, { isLoading }] = useAuthGet({
    route: "/manager/overview",
    onFailure: toast,
    defaultValue: { movies: [] }
  });

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "movname",
      name: "Movie Name"
    },
    {
      key: "movduration",
      name: "Movie Duration",
      filterRenderer: NumericFilter
    },
    {
      key: "movreleasedate",
      name: "Release Date",
      filterRenderer: DateFilter
    },
    {
      key: "movplaydate",
      name: "Play Date",
      filterRenderer: DateFilter
    }
  ].map(c => ({ ...baseColumn, ...c }));

  // Filter unscheduled
  const [showUnscheduled, setShowUnscheduled] = useState(false);
  const onToggleShowUnscheduled = useCallback(
    () => setShowUnscheduled(!showUnscheduled),
    [showUnscheduled]
  );
  const filteredData = useMemo(
    () =>
      showUnscheduled
        ? movies.filter(({ movplaydate }) => isNil(movplaydate))
        : movies,
    [movies, showUnscheduled]
  );

  return (
    <AppBase title="Theater Overview" level="manager">
      <div className="theater-overview">
        <DataGrid
          isLoading={isLoading}
          data={filteredData}
          columns={columns}
          canDeleteRow={() => false}
          columnWidths={{
            base: [200, 170, 220, 220],
            "992": [300, 140, 280, 280],
            "1200": [null, 200, 300, 300]
          }}
          toolbarComponents={
            <Switch
              onChange={onToggleShowUnscheduled}
              checked={showUnscheduled}
              label="Only Include Unscheduled"
              className="control-spacing"
            />
          }
        />
      </div>
    </AppBase>
  );
}
TheaterOverview.displayName = "TheaterOverview";
