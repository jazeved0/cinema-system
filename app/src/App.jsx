import React from "react";
import { AuthContext, useAuthStore } from "Authentication";

import { Layout, SecondaryNav } from "Components";
import { NotFound, LoginRegister, AppRoot } from "Pages";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

const registerScreens = ["user", "customer", "manager", "manager-customer"];
export default function App() {
  const authState = useAuthStore();
  return (
    <Router>
      <AuthContext.Provider value={authState}>
        <Layout>
          <Switch>
            {/* Registration/login pages */}
            <Route
              exact
              path={[
                "/",
                "/register",
                ...registerScreens.map(c => `/register/${c}`)
              ]}
            >
              <LoginRegister />
            </Route>
            <Route path="*">
              {/* App pages */}
              <SecondaryNav />
              <Switch>
                <Route path="/app">
                  <AppRoot />
                </Route>
                <Route path="*">
                  <NotFound />
                </Route>
              </Switch>
            </Route>
          </Switch>
        </Layout>
      </AuthContext.Provider>
    </Router>
  );
}
App.displayName = "App";
