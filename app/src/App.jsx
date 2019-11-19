import React from "react";

import { Layout, SecondaryNav } from "Components";
import { NotFound, LoginRegister } from "Pages";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";

const registerScreens = ["user", "customer", "manager", "manager-customer"];
function App() {
  return (
    <Router>
      <Layout>
        <Switch>
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
            <SecondaryNav />
            <NotFound />
          </Route>
        </Switch>
      </Layout>
    </Router>
  );
}

export default App;
