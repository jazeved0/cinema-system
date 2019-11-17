import React from "react";

import { Layout, SecondaryNav } from "Components";
import {
  Login,
  Register,
  NotFound,
  RegisterUser,
  RegisterCustomer
} from "Pages";
import { BrowserRouter as Router, Switch, Route } from "react-router-dom";
import { Container } from "react-bootstrap";

function App() {
  return (
    <Router>
      <Layout>
        <SecondaryNav />
        <Container>
          <Switch>
            <Route exact path="/">
              <Login />
            </Route>
            <Route exact path="/register">
              <Register />
            </Route>
            <Route exact path="/register/user">
              <RegisterUser />
            </Route>
            <Route exact path="/register/customer">
              <RegisterCustomer />
            </Route>
            <Route path="*">
              <NotFound />
            </Route>
          </Switch>
        </Container>
      </Layout>
    </Router>
  );
}

export default App;
