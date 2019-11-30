import React, { useCallback, useReducer, useContext, useRef } from "react";
import { isDefined } from "Utility";

export const NotificationContext = React.createContext(
  getDefaultNotificationContext()
);

function getDefaultNotificationContext() {
  return {
    toast: [],
    alert: []
  };
}

export function useNotifications() {
  return useContext(NotificationContext);
}

function notificationReducer(state, action) {
  console.log(state);
  switch (action.type) {
    case "dismiss": {
      const { type, id } = action.payload;
      if (state[type].findIndex(n => n.id === id) === -1) return state;
      return {
        ...state,
        [type]: state[type].filter(notification => notification.id !== id)
      };
    }
    case "show": {
      const { type, ...rest } = action.payload;
      return {
        ...state,
        [type]: [...state[type], rest]
      };
    }
    default:
      throw new Error();
  }
}

export function useNotificationStore() {
  const [state, dispatch] = useReducer(
    notificationReducer,
    getDefaultNotificationContext()
  );

  const onDismissToast = useCallback(
    id => dispatch({ type: "dismiss", payload: { type: "toast", id } }),
    [dispatch]
  );
  const onDismissAlert = useCallback(
    id => dispatch({ type: "dismiss", payload: { type: "alert", id } }),
    [dispatch]
  );

  const currentIdRef = useRef(0);
  const showNotification = useCallback(
    ({ message = "", duration = null, type = "toast", variant = "danger" }) => {
      const id = currentIdRef.current++;
      dispatch({
        type: "show",
        payload: { type, variant, message, id }
      });
      if (isDefined(duration)) {
        setTimeout(
          () => dispatch({ type: "dismiss", payload: { type, id } }),
          duration
        );
      }
    },
    [dispatch]
  );

  const showAlert = useCallback(
    props => showNotification({ type: "alert", ...props }),
    [showNotification]
  );
  const showToast = useCallback(
    props => showNotification({ type: "toast", ...props }),
    [showNotification]
  );

  const toast = useCallback((message, variant = "danger", duration = 8000) =>
    showToast({ message, variant, duration })
  );
  const alert = useCallback((message, variant = "danger", duration = 8000) =>
    showAlert({ message, variant, duration })
  );

  return {
    toasts: state.toast,
    alerts: state.alert,
    onDismissToast,
    onDismissAlert,
    showAlert,
    showToast,
    toast,
    alert
  };
}
