import React, { useContext, useState } from "react";
import { isDefined } from "Utility";

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
    loadAuth: () => null,
    onLogout: () => null
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

const debugUser = {
  token: "aaaaaa",
  isAdmin: false,
  isManager: true,
  isCustomer: true,
  username: "jdoe3",
  firstName: "John",
  lastName: "Doe",
  loadAuth: () => null,
  onLogout: () => null
};

// TODO remove debug user line once API is implemented
export function useAuthStore() {
  // const [authState, setAuthState] = useState(() => getDefaultAuthState());
  const [authState, setAuthState] = useState(debugUser);
  console.log(authState);
  return {
    ...authState,
    isAuthenticated: isDefined(authState.token),
    userType: getUserType(authState),
    loadAuth: session => setAuthState({ ...authState, ...session }),
    onLogout: () => setAuthState(getDefaultAuthState())
  };
}
