import React from "react";
import { useAuthGet, performAuthRequest } from "Api";
import { useCallbackOnce } from "Utility";
import { useNotifications } from "Notifications";
import { useAuth } from "Authentication";

import { AppBase } from "Pages";
import { DataGrid, Icon } from "Components";
import { NumericFilter, ComboFilter } from "Components/DataGrid";

export default function ManageUser() {
  // Fetch API data
  const [{ users }, { isLoading, update: setUsers }] = useAuthGet({
    route: "/users",
    defaultValue: { users: [] }
  });

  // Column definitions
  const baseColumn = {
    sortable: true,
    filterable: true,
    resizable: true
  };
  const columns = [
    {
      key: "username",
      name: "Username"
    },
    {
      key: "creditcardcount",
      name: "Credit Card Count",
      filterRenderer: NumericFilter
    },
    {
      key: "usertype",
      name: "User Type"
    },
    {
      key: "status",
      name: "Status",
      filterRenderer: props => (
        <ComboFilter
          options={["All", "Pending", "Approved", "Declined"]}
          {...props}
        />
      )
    }
  ].map(c => ({ ...baseColumn, ...c }));

  const { token } = useAuth();
  const { toast } = useNotifications();
  const onDecline = useCallbackOnce(({ username }) =>
    performAuthRequest(`/users/${username}/decline`, "put", token, {
      onFailure: error => toast(error),
      onSuccess: () => {
        toast(`User ${username} declined`, "success");
        setUsers(state => ({
          ...state,
          users: state.users.map(u =>
            u.username === username ? { ...u, status: "Declined" } : u
          )
        }));
      }
    })
  );
  const onApprove = useCallbackOnce(({ username }) =>
    performAuthRequest(`/users/${username}/approve`, "put", token, {
      onFailure: error => toast(error),
      onSuccess: () => {
        toast(`User ${username} approved`, "success");
        setUsers(state => ({
          ...state,
          users: state.users.map(u =>
            u.username === username ? { ...u, status: "Approved" } : u
          )
        }));
      }
    })
  );

  return (
    <AppBase title="Manage User" level="admin">
      <DataGrid
        data={users}
        columns={columns}
        columnWidths={{
          base: [300, 190, 190, 190],
          "992": [null, 190, 190, 190]
        }}
        isLoading={isLoading}
        canDeleteRow={() => false}
        getRowActions={row => {
          const actions = [];
          if (!isLoading) {
            const status = row.status.trim();
            if (status === "Pending") {
              actions.push({
                icon: <Icon name="times-circle" size="lg" noAutoWidth />,
                callback: () => {
                  onDecline(row);
                }
              });
            }
            if (status !== "Approved") {
              actions.push({
                icon: <Icon name="check-circle" size="lg" noAutoWidth />,
                callback: () => {
                  onApprove(row);
                }
              });
            }
          }
          return actions;
        }}
      />
    </AppBase>
  );
}
ManageUser.displayName = "ManageUser";
