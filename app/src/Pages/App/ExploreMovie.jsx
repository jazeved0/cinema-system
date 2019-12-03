import React, { useMemo, useRef, useCallback, useState } from "react";
import {
  formatDate,
  identity,
  useCallbackOnce,
  isDefined,
  formatCreditCard
} from "Utility";
import { useAuthGet, performAuthRequest } from "Api";
import { useNotifications } from "Notifications";
import { useAuth } from "Authentication";

import { AppBase } from "Pages";
import { Circle } from "rc-progress";
import { Form as BootstrapForm } from "react-bootstrap";
import { Placeholder, DataGrid, Icon, Form } from "Components";
import {
  AddressFormatter,
  ComboFilter,
  PopoverFilter
} from "Components/DataGrid";
import { pick } from "lodash";

import { primaryColor } from "global.json";

const MAX_DAILY_VIEWS = 3;

export default function ExploreMovie() {
  // Fetch views from API
  const { toast } = useNotifications();
  const [{ views }, { isLoading: viewsLoading, update: setViews }] = useAuthGet(
    {
      route: "/movies/views",
      defaultValue: { views: [] },
      onFailure: toast
    }
  );

  // Calculate views from today to display for quota
  const todayDate = formatDate(new Date());
  const viewsToday = useMemo(() => {
    return views.filter(({ playdate }) => playdate === todayDate).length;
  }, [views, todayDate]);
  const quotaPercentage = (viewsToday / MAX_DAILY_VIEWS) * 100;

  // Fetch movies
  const [{ movies }, { isLoading: moviesLoading }] = useAuthGet({
    route: "/movies/explore",
    defaultValue: { movies: [] },
    onFailure: toast
  });

  // Filter out movies that the user has already seen
  const filteredMovies = useMemo(() => {
    const fields = [
      "companyname",
      "moviename",
      "playdate",
      "releasedate",
      "theatername"
    ];
    const userPlaySet = new Set(
      views.map(v => JSON.stringify(pick(v, fields)))
    );
    return movies.filter(({ date, ...rest }) => {
      const moviePlay = pick({ playdate: date, ...rest }, fields);
      return !userPlaySet.has(JSON.stringify(moviePlay));
    });
  }, [movies, views]);

  // Fetch company names
  let [{ companies }] = useAuthGet({
    route: "/companies",
    config: { params: { only_names: true } },
    defaultValue: { companies: [] }
  });

  // Use refs to bypass incorrect filter generation usage
  const companyNameRef = useRef([]);
  companyNameRef.current = companies;
  const movieNameRef = useRef([]);
  movieNameRef.current = useMemo(
    () => Array.from(new Set(filteredMovies.map(({ moviename }) => moviename))),
    [filteredMovies]
  );

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "moviename",
      name: "Movie Name",
      optionsGetter: () => movieNameRef.current,
      filterRenderer: ComboFilter
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
      optionsGetter: () => companyNameRef.current,
      filterRenderer: ComboFilter
    },
    {
      key: "date",
      name: "Play Date",
      filterRenderer: PopoverFilter,
      popoverFilter: PopoverFilter.Date
    }
  ].map(c => ({ ...baseColumn, ...c }));

  // Credit card number selection combo box
  const [creditCard, setCreditCard] = useState(null);
  const onChangeCreditCard = useCallbackOnce((_, e) => setCreditCard(e));
  const [{ creditCards }, { isLoading: creditCardsLoading }] = useAuthGet({
    route: "/users/credit-cards",
    defaultValue: { creditCards: [] },
    onSuccess: ({ creditCards }) => {
      if (isDefined(creditCards) && creditCards.length > 0) {
        setCreditCard({ label: creditCards[0], value: creditCards[0] });
      }
    }
  });

  // Watch button
  const { token, username } = useAuth();
  const watch = useCallback(
    movie => {
      performAuthRequest("/movies/views", "post", token, {
        config: {
          data: {
            moviename: movie.moviename,
            releasedate: movie.releasedate,
            playdate: movie.date,
            theatername: movie.theatername,
            companyname: movie.companyname,
            creditcardnum: creditCard.value
          }
        },
        onSuccess: () => {
          toast(
            `Movie ${movie.moviename} successfully viewed on ${movie.date}`,
            "success"
          );
          setViews(({ views }) => ({
            views: [
              ...views,
              {
                moviename: movie.moviename,
                releasedate: movie.releasedate,
                playdate: movie.date,
                theatername: movie.theatername,
                companyname: movie.companyname,
                creditcardnum: creditCard.value,
                owner: username
              }
            ]
          }));
        },
        onFailure: toast,
        retry: false
      });
    },
    [creditCard, toast, token, username, setViews]
  );

  return (
    <AppBase title="Explore Movie" level="customer">
      <div className="explore-movie__watch">
        <h4 className="explore-movie__watch-label">Daily Watch Limit</h4>
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
      <div className="explore-movie__credit-card">
        <BootstrapForm.Group>
          <BootstrapForm.Label>Credit Card:</BootstrapForm.Label>
          <Form.Input
            type="combo"
            inputKey={null}
            placeholder={"Select credit card"}
            onChange={onChangeCreditCard}
            value={creditCard}
            onBlur={identity}
            onKeyDown={identity}
            isClearable={false}
            options={creditCards}
            disabled={creditCardsLoading}
            isInvalid={!creditCardsLoading && creditCards.length === 0}
            message={"You must have at least one credit card to view a movie"}
            getOptionLabel={({ label }) => formatCreditCard(label)}
          />
        </BootstrapForm.Group>
      </div>
      <DataGrid
        data={filteredMovies}
        columns={columns}
        canDeleteRow={() => false}
        columnWidths={{
          base: [180, 160, 300, 180, 200],
          "992": [180, 130, 300, 180, 190],
          "1200": [230, 130, 300, 200, null]
        }}
        isLoading={moviesLoading || viewsLoading}
        getRowActions={row => {
          if (moviesLoading || creditCards.length === 0) return [];
          else if (viewsToday >= MAX_DAILY_VIEWS && row.playdate === todayDate)
            return [];
          else
            return [
              {
                icon: <Icon name="arrow-circle-right" size="lg" noAutoWidth />,
                callback: () => watch(row)
              }
            ];
        }}
      />
    </AppBase>
  );
}
ExploreMovie.displayName = "ExploreMovie";
