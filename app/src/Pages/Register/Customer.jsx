import React, { useState } from "react";

import { Card, Form, CreditCardDisplay } from "Components";
import { RegisterBase } from "Pages";

export default function RegisterCustomer() {
  const [isLoading, setIsLoading] = useState(false);

  // TODO implement API functionality
  // TODO display non-unique username error
  // TODO display non-unique cc number error
  return (
    <RegisterBase title="Customer Registration" name="customer">
      <p className="lead">
        Register a new customer. <em>Note: all fields are required.</em>
      </p>
      <Card>
        <Form
          onSubmit={() => setIsLoading(true)}
          isLoading={isLoading}
          isShown={true}
          collapse="md"
          blocking
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
            },
            {
              key: "credit_cards",
              required: true,
              name: "Credit Cards",
              type: "set",
              props: {
                setValidator: ({ value }) => {
                  return {
                    result: value.length === 19,
                    message: "Credit card must be 16 characters long"
                  };
                },
                processValue: value => {
                  const numeric = value.replace(/\D/g, "");
                  const formatted = numeric.replace(/(.{4})/g, "$1 ");
                  const trimmed = formatted.substring(0, 20);
                  if (trimmed.charAt(trimmed.length - 1) === " ") {
                    return trimmed.slice(0, -1);
                  } else return trimmed;
                },
                max: 5,
                renderItem: item => <CreditCardDisplay text={item} />,
                className: "credit-card-input"
              }
            }
          ]}
          submit={{
            variant: "secondary",
            text: "Register"
          }}
        />
      </Card>
    </RegisterBase>
  );
}
RegisterCustomer.displayName = "RegisterCustomer";
