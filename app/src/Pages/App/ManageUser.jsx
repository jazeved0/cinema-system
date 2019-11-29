import React from "react";
import { useAuthGet, performAuthRequest } from "Api";
import { useCallbackOnce } from "Utility";
import { useNotifications } from "Notifications";
import { useAuth } from "Authentication";

import { AppBase } from "Pages";
import { DataGrid, Icon } from "Components";
import { NumericFilter } from "Components/DataGrid";

export default function ManageUser() {
  // Fetch API data
  const [users, isLoading, adjustCache] = useAuthGet("/users");

  // Column definitions
  const columns = [
    {
      key: "username",
      name: "Username",
      sortable: true,
      filterable: true,
      resizable: true
    },
    {
      key: "creditcardcount",
      name: "Credit Card Count",
      filterRenderer: NumericFilter,
      sortable: true,
      filterable: true,
      resizable: true
    },
    {
      key: "usertype",
      name: "User Type",
      sortable: true,
      filterable: true,
      resizable: true
    },
    {
      key: "status",
      name: "Status",
      sortable: true,
      filterable: true,
      resizable: true
    }
  ];

  const { token } = useAuth();
  const { showToast } = useNotifications();
  const onDecline = useCallbackOnce(({ username }) =>
    performAuthRequest(`/users/${username}/decline`, "put", token, {
      onFailure: error => showToast({ message: error, duration: 30000 }),
      onSuccess: () => {
        showToast({
          message: `User ${username} declined`,
          variant: "success",
          duration: 30000
        });
        adjustCache(user_list =>
          user_list.map(u =>
            u.username === username ? { ...u, status: "Declined" } : u
          )
        );
      }
    })
  );
  const onApprove = useCallbackOnce(({ username }) =>
    performAuthRequest(`/users/${username}/approve`, "put", token, {
      onFailure: error => showToast({ message: error, duration: 30000 }),
      onSuccess: () => {
        showToast({
          message: `User ${username} approved`,
          variant: "success",
          duration: 30000
        });
        adjustCache(user_list =>
          user_list.map(u =>
            u.username === username ? { ...u, status: "Approved" } : u
          )
        );
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
