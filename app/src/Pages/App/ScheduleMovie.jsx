import React, { useState, useMemo } from "react";
import { useAuthForm, useAuthGet } from "Api";
import { useNotifications } from "Notifications";
import { useHistory } from "react-router-dom";
import { useCallbackOnce, formatDate, isDefined } from "Utility";

import { Button } from "react-bootstrap";
import { Form, Card } from "Components";
import { AppBase } from "Pages";

export default function ScheduleMovie() {
  // Main API form submission
  const [isBlocking, setIsBlocking] = useState(true);
  const { toast } = useNotifications();
  const history = useHistory();
  const { isLoading, onSubmit } = useAuthForm({
    path: "/movies/schedule",
    onFailure: toast,
    onSuccess: () => {
      setIsBlocking(false);
      toast("Movie scheduled successfully", "success");
    }
  });
  const onFormSubmit = useCallbackOnce(({ name, playDate, releaseDate }) =>
    onSubmit({
      moviename: name,
      releasedate: formatDate(releaseDate),
      playdate: formatDate(playDate)
    })
  );

  // List of movies
  const [{ movies }] = useAuthGet({
    route: "/movies",
    defaultValue: { movies: [] }
  });
  const movieNames = useMemo(() => movies.map(({ name }) => name), [movies]);

  return (
    <AppBase title="Schedule Movie" level="manager">
      <Card>
        <Form
          onSubmit={onFormSubmit}
          isShown
          isBlocking={isBlocking}
          isLoading={isLoading}
          reverseButtons
          submit={{
            variant: "secondary",
            text: "Schedule"
          }}
          buttons={
            <Button
              variant="outline-primary"
              onClick={() => history.push("/app")}
            >
              Back
            </Button>
          }
          entries={[
            {
              key: "name",
              name: "Name",
              type: "combo",
              props: {
                options: movieNames
              },
              required: true
            },
            {
              key: "releaseDate",
              name: "Release Date",
              required: true,
              type: "date",
              width: 6
            },
            {
              key: "playDate",
              name: "Play Date",
              required: true,
              type: "date",
              width: 6,
              validator: ({ value, values }) => {
                if (isDefined(values.releaseDate) && isDefined(value)) {
                  if (formatDate(values.releaseDate) > formatDate(value)) {
                    return {
                      result: false,
                      message: "Play date cannot occur before release date"
                    };
                  }
                }
              }
            }
          ]}
        />
      </Card>
    </AppBase>
  );
}
ScheduleMovie.displayName = "ScheduleMovie";
