import React, { useContext, useState } from "react";
import { isDefined } from "Utility";

const LOCAL_STORAGE_KEY = "session";

export const AuthContext = React.createContext(getDefaultAuthState());

export function useAuth() {
  return useContext(AuthContext);
}

export function getDefaultAuthState() {
  return {
    token: null,
    isAdmin: false,
    isManager: false,
    isCustomer: false,
    username: null,
    firstName: null,
    lastName: null
  };
}

function getUserType({ isAdmin, isCustomer, isManager }) {
  const base = isAdmin ? "Admin" : isManager ? "Manager" : null;
  const suffix = isCustomer ? "Customer" : null;
  return isDefined(base)
    ? isDefined(suffix)
      ? `${base}-${suffix}`
      : base
    : isDefined(suffix)
    ? suffix
    : "User";
}

function getInitialAuthState() {
  const storedSession = window.localStorage.getItem(LOCAL_STORAGE_KEY);
  if (isDefined(storedSession)) {
    return JSON.parse(storedSession);
  } else {
    return getDefaultAuthState();
  }
}

export function useAuthStore() {
  function store(session) {
    setAuthState(session);
    // Persist session in local storage
    window.localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(session));
  }

  const login = session => store({ ...authState, ...session });
  const logout = () => store(getDefaultAuthState());

  const [authState, setAuthState] = useState(getInitialAuthState);
  console.log(authState);
  return {
    ...authState,
    isAuthenticated: isDefined(authState.token),
    userType: getUserType(authState),
    loadAuth: login,
    onLogout: logout
  };
}
