import React, { useState, useMemo } from "react";
import { states, createObject, isNil, isEmptyOrNil, isDefined } from "Utility";
import { useAuthForm, useCompanies, useAuthGet } from "Api";
import { useNotifications } from "Notifications";

import { Button } from "react-bootstrap";
import { Form, Card } from "Components";

export default function CreateTheaterForm({ show, onHide, onAdd }) {
  const [isBlocking, setIsBlocking] = useState(true);
  const { toast } = useNotifications();
  const {
    isLoading: isTheaterLoading,
    onSubmit: onCreateTheater
  } = useAuthForm({
    path: "/theaters",
    onFailure: toast,
    onSuccess: ({ data }) => {
      setIsBlocking(false);
      toast("Theater created successfully", "success");
      onAdd(data);
    }
  });

  // Company name list
  const companies = useCompanies();

  // ELigible managers
  const [{ managers }] = useAuthGet({
    route: "/managers/eligible",
    defaultValue: { managers: [] }
  });

  const companyToManagers = useMemo(() => {
    let map = createObject();
    for (const manager of managers) {
      const { companyname, ...rest } = manager;
      if (isNil(map[companyname])) map[companyname] = [rest];
      else map[companyname].push(rest);
    }
    return map;
  }, [managers]);

  return (
    <Card>
      <Form
        onSubmit={onCreateTheater}
        isShown={show}
        isBlocking={isBlocking}
        isLoading={isTheaterLoading}
        reverseButtons
        submit={{
          variant: "secondary",
          text: "Create"
        }}
        buttons={
          <Button variant="outline-primary" onClick={onHide}>
            Cancel
          </Button>
        }
        entries={[
          { key: "theatername", required: true, name: "Name", width: 6 },
          {
            key: "companyname",
            required: true,
            name: "Company",
            type: "combo",
            props: {
              getOptions: ({ values }) => {
                if (!isEmptyOrNil(values.manager)) {
                  const managerEntity = managers.find(
                    ({ username }) => username === values.manager.value
                  );
                  if (isDefined(managerEntity)) {
                    return [managerEntity.companyname];
                  }
                }
                return companies;
              }
            },
            width: 6
          },
          {
            key: "street",
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
            key: "capacity",
            type: "numeric",
            required: true,
            name: "Capacity",
            width: 5,
            props: {
              min: 1,
              integer: true
            }
          },
          {
            key: "manager",
            type: "combo",
            required: true,
            name: "Manager",
            width: 7,
            validator: ({ value, values }) => {
              if (!isEmptyOrNil(values.companyname)) {
                const eligible = companyToManagers[values.companyname.value];
                if (
                  isNil(eligible) ||
                  eligible.findIndex(
                    ({ username }) => value.value === username
                  ) === -1
                ) {
                  return {
                    result: false,
                    message: "Manager must work for selected company"
                  };
                }
              }
            },
            props: {
              getOptions: ({ values }) => {
                let options = [];
                if (!isEmptyOrNil(values.companyname)) {
                  const eligible = companyToManagers[values.companyname.value];
                  options = eligible || [];
                } else {
                  options = managers;
                }
                return options.map(({ firstname, lastname, username }) => ({
                  value: username,
                  label: `${firstname} ${lastname}`
                }));
              }
            }
          }
        ]}
      />
    </Card>
  );
}

CreateTheaterForm.displayName = "CreateTheaterForm";
