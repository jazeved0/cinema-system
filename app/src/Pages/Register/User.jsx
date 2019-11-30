import React, { useState } from "react";
import { useApiForm } from "Api";
import { useAuth, decodeJWT } from "Authentication";

import { Card, Form, NotificationList } from "Components";
import { RegisterBase } from "Pages";

export default function RegisterUser() {
  const [isBlocking, setIsBlocking] = useState(true);
  const { loadAuth } = useAuth();
  const {
    errorContext: { errors, onDismiss },
    isLoading,
    onSubmit
  } = useApiForm({
    path: "/register/user",
    onSuccess: ({response}) => {
      const { token } = response;
      setIsBlocking(false);
      const session = decodeJWT(token);
      loadAuth({ ...session, token });
    }
  });

  return (
    <RegisterBase title="User Registration" name="user">
      <p className="lead">
        Register a new user. <em>Note: all fields are required.</em>
      </p>
      <Card>
        <NotificationList
          type="toast"
          items={errors}
          onDismiss={onDismiss}
          transitionLength={750}
        />
        <Form
          onSubmit={onSubmit}
          isLoading={isLoading}
          blocking={isBlocking}
          collapse="md"
          entries={[
            { key: "first_name", required: true, name: "First Name", width: 6 },
            { key: "last_name", required: true, name: "Last Name", width: 6 },
            { key: "username", required: true, name: "Username", prefix: "@" },
            {
              key: "password",
              required: true,
              name: "Password",
              type: "password",
              validator: ({ value, values, hasSubmitted }) => {
                if (value.length < 8) {
                  return {
                    result: false,
                    message: "Password must be at least 8 characters long"
                  };
                }

                if (hasSubmitted && value !== values.password_confirm) {
                  return {
                    result: false,
                    message: "Password and confirm password must match"
                  };
                }
              }
            },
            {
              key: "password_confirm",
              required: true,
              name: "Confirm Password",
              type: "password",
              validator: ({ value, values, hasSubmitted }) => {
                if (hasSubmitted && value !== values.password) {
                  return {
                    result: false,
                    message: "Password and confirm password must match"
                  };
                }
              }
            }
          ]}
          submit={{
            variant: "secondary",
            text: "Register"
          }}
        ></Form>
      </Card>
    </RegisterBase>
  );
}
RegisterUser.displayName = "RegisterUser";
