import React from "react";
import { useNotificationStore, NotificationContext } from "Notifications";

import { NotificationList } from "Components";

export default function NotificationStore({ children }) {
  const notifications = useNotificationStore();
  const { toasts, alerts, onDismissToast, onDismissAlert } = notifications;

  return (
    <>
      <NotificationContext.Provider value={notifications}>
        {children}
      </NotificationContext.Provider>
      <div className="notification-pane">
        <NotificationList
          className="notification-pane--toast"
          items={toasts}
          type="toast"
          onDismiss={onDismissToast}
        />
        <NotificationList
          className="notification-pane--alert"
          items={alerts}
          type="alert"
          onDismiss={onDismissAlert}
          container
        />
      </div>
    </>
  );
}
