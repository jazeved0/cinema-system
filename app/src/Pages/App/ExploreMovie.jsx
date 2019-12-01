import React, { useMemo, useRef } from "react";
import { formatDate } from "Utility";
import { useAuthGet } from "Api";
import { useNotifications } from "Notifications";

import { AppBase } from "Pages";
import { Circle } from "rc-progress";
import { Placeholder, DataGrid } from "Components";
import {
  AddressFormatter,
  ComboFilter,
  PopoverFilter
} from "Components/DataGrid";

import { primaryColor } from "global.json";

const MAX_DAILY_VIEWS = 3;

export default function ExploreMovie() {
  // Fetch views from API
  const { toast } = useNotifications();
  const [{ views }, { isLoading: viewsLoading }] = useAuthGet({
    route: "/views",
    defaultValue: { views: [] },
    onFailure: toast
  });

  // Calculate views from today to display for quota
  const viewsToday = useMemo(() => {
    const today = formatDate(new Date());
    return views.filter(({ playdate }) => playdate === today).length;
  }, [views]);
  const quotaPercentage = (viewsToday / MAX_DAILY_VIEWS) * 100;

  // Fetch movies
  const [{ movies }, { isLoading: moviesLoading }] = useAuthGet({
    route: "/movies/explore",
    defaultValue: { movies: [] },
    onFailure: toast
  });

  // Fetch company names
  let [{ companies }] = useAuthGet({
    route: "/companies",
    config: { params: { only_names: true } },
    defaultValue: { companies: [] }
  });

  // Use ref to bypass incorrect generation usage
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
      key: "moviename",
      name: "Movie Name"
    },
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
      filterRenderer: props => (
        <ComboFilter options={companyNameRef.current} {...props} />
      )
    },
    {
      key: "date",
      name: "Play Date",
      filterRenderer: PopoverFilter,
      popoverFilter: PopoverFilter.Date
    }
  ].map(c => ({ ...baseColumn, ...c }));

  return (
    <AppBase title="Explore Movie" level="customer">
      <div className="explore-movie__watch">
        <h4 className="explore-movie__watch-label">Daily Watch Quota</h4>
        <div className="explore-movie__watch-progress">
          <Circle
            percent={quotaPercentage}
            strokeWidth="8"
            strokeColor={primaryColor}
          />
          <div className="explore-movie__watch-progress-label-wrapper">
            <Placeholder.Text
              className="explore-movie__watch-progress-label h4"
              text={viewsLoading ? null : viewsToday.toString()}
              size="2.5rem"
              width={40}
              auto
            />
          </div>
        </div>
      </div>
      <DataGrid
        data={movies}
        columns={columns}
        columnWidths={{
          base: [180, 160, 300, 180, 200],
          "992": [180, 130, 300, 180, 190],
          "1200": [230, 130, 300, 200, null]
        }}
        isLoading={moviesLoading}
      />
    </AppBase>
  );
}
ExploreMovie.displayName = "ExploreMovie";
