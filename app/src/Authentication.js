import React, { useContext, useState } from "react";
import { isDefined, log } from "Utility";
import jwt_decode from "jwt-decode";

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
    lastName: null,
    status: null,
    ccCount: null
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
    log("Loaded session data from localstorage");
    return JSON.parse(storedSession);
  } else {
    return getDefaultAuthState();
  }
}

export function decodeJWT(jwt) {
  return jwt_decode(jwt);
}

export function useAuthStore() {
  const login = session => {
    const newSession = { ...authState, ...session };
    setAuthState(newSession);
    window.localStorage.setItem(LOCAL_STORAGE_KEY, JSON.stringify(newSession));
  };

  const logout = () => {
    setAuthState(getDefaultAuthState());
    window.localStorage.removeItem(LOCAL_STORAGE_KEY);
  };

  const [authState, setAuthState] = useState(getInitialAuthState);
  return {
    ...authState,
    isAuthenticated: isDefined(authState.token),
    userType: getUserType(authState),
    loadAuth: login,
    onLogout: logout
  };
}
