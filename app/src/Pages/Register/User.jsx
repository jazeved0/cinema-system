import React, { useState } from "react";
import { Card, Form } from "Components";

export default function RegisterUser() {
  const [isLoading, setIsLoading] = useState(false);

  // TODO implement API functionality
  // TODO display non-unique username error
  return (
    <div className="register-user">
      <h1 className="intro-space">User Registration</h1>
      <p className="lead">
        Register a new user. <em>Note: all fields are required.</em>
      </p>
      <Card style={{ maxWidth: "980px" }}>
        <Form
          onSubmit={() => setIsLoading(true)}
          isLoading={isLoading}
          isShown={true}
          collapse="md"
          entries={[
            { key: "first_name", required: true, name: "First Name" },
            { key: "last_name", required: true, name: "Last Name" },
            { key: "username", required: true, name: "Username" },
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
    </div>
  );
}
RegisterUser.displayName = "RegisterUser";
