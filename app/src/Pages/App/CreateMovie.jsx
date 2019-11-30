import React, { useState } from "react";
import { useAuthForm } from "Api";
import { useNotifications } from "Notifications";
import { useHistory } from "react-router-dom";

import { Button } from "react-bootstrap";
import { Form, Card } from "Components";
import { AppBase } from "Pages";

export default function CreateMovie() {
  const [isBlocking, setIsBlocking] = useState(true);
  const { toast } = useNotifications();
  const history = useHistory();
  const { isLoading, onSubmit } = useAuthForm({
    path: "/movies",
    onFailure: toast,
    onSuccess: () => {
      setIsBlocking(false);
      toast("Movie created successfully", "success");
    }
  });

  return (
    <AppBase title="Create Movie" level="admin">
      <Card>
        <Form
          onSubmit={onSubmit}
          isShown
          isBlocking={isBlocking}
          isLoading={isLoading}
          reverseButtons
          submit={{
            variant: "secondary",
            text: "Create"
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
            { key: "name", name: "Name", required: true, width: 6 },
            {
              key: "duration",
              name: "Duration",
              width: 6,
              type: "numeric",
              required: true,
              defaultValue: "60",
              props: {
                min: 1
              }
            },
            // TODO implement date picker input
            { key: "releasedate", name: "Release Date", required: true }
          ]}
        />
      </Card>
    </AppBase>
  );
}
CreateMovie.displayName = "CreateMovie";
