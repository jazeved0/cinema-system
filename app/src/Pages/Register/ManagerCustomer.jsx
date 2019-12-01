import React, { useState } from "react";
import { states, processCreditCardInput } from "Utility";
import { useApiForm, useCompanies } from "Api";
import { useNotifications } from "Notifications";
import { useAuth, decodeJWT } from "Authentication";
import { useHistory } from "react-router-dom";

import { Card, Form, CreditCardDisplay, NotificationList } from "Components";
import { RegisterBase } from "Pages";

export default function ManagerCustomer() {
  const [isBlocking, setIsBlocking] = useState(true);
  const { loadAuth } = useAuth();
  const { toast } = useNotifications();
  const history = useHistory();
  const companies = useCompanies();
  const {
    errorContext: { errors, onDismiss },
    isLoading,
    onSubmit
  } = useApiForm({
    path: "/register/manager-customer",
    onSuccess: ({ response }) => {
      const { token } = response;
      setIsBlocking(false);
      const session = decodeJWT(token);
      loadAuth({ ...session, token });
      history.push("/app");
      toast("Registered successfully");
    }
  });

  return (
    <RegisterBase title="Manager-Customer Registration" name="manager-customer">
      <p className="lead">
        Register a new joint manager-customer.{" "}
        <em>Note: all fields are required.</em>
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
            {
              key: "username",
              required: true,
              name: "Username",
              prefix: "@",
              width: 8
            },
            {
              key: "company",
              required: true,
              name: "Company",
              type: "combo",
              props: { options: companies },
              width: 4
            },
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
              key: "street_address",
              required: true,
              name: "Street Address"
            },
            {
              key: "city",
              required: true,
              name: "City",
              width: 5
            },
            {
              key: "state",
              type: "combo",
              required: true,
              name: "State",
              width: 3,
              props: {
                options: states
              }
            },
            {
              key: "zipcode",
              required: true,
              name: "Zipcode",
              width: 4,
              validator: ({ value }) => {
                if (value.length !== 5) {
                  return {
                    result: false,
                    message: "Zipcode must be 5 characters long"
                  };
                }
              },
              processValue: value => {
                const numeric = value.replace(/\D/g, "");
                return numeric;
              },
              props: {
                maxLength: 5
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
                processValue: processCreditCardInput,
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
ManagerCustomer.displayName = "ManagerCustomer";
