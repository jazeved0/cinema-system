import React, { useMemo } from "react";
import { useAuth } from "Authentication";
import { useAllRoutes, useUnauthorizedRoutes } from "Routes";

import { AppMenu, NotFound } from "Pages";
import { Switch, Route } from "react-router-dom";
import { Redirect, NotificationPane } from "Components";
import { splitPath } from "Utility";

export default function AppRoot() {
  const base = "/app";
  const redirects = useMenuRedirects(base);
  const unauthorizedRedirects = useUnauthorizedRedirects(base);
  const routes = useAllRoutes();
  const { isAuthenticated } = useAuth();
  const generatedRoutes = routes.map(({ to, page: Page, exact = true }) => (
    <Route key={to} path={base + to} exact={exact}>
      <Page />
    </Route>
  ));
  return (
    <NotificationPane>
      <Switch>
        {Redirect({ when: !isAuthenticated, to: "/" })}
        {Redirect({ from: unauthorizedRedirects, to: base, exact: true })}
        {Redirect({ from: redirects, to: base, exact: true })}
        <Route path={base} exact>
          <AppMenu base={base} />
        </Route>
        {generatedRoutes}
        <Route path="*">
          <NotFound />
        </Route>
      </Switch>
    </NotificationPane>
  );
}
AppRoot.displayName = "AppRoot";

function useMenuRedirects(base) {
  const routes = useAllRoutes();
  return useMemo(() => routes.map(({ to }) => `${base}/${splitPath(to)[0]}`), [
    routes,
    base
  ]);
}

function useUnauthorizedRedirects(base) {
  const { isAdmin, isManager, isCustomer } = useAuth();
  const routesComplement = useUnauthorizedRoutes({
    isAdmin,
    isManager,
    isCustomer
  });
  return useMemo(() => routesComplement.map(({ to }) => base + to), [
    routesComplement,
    base
  ]);
}
