import React, { useMemo } from "react";
import { useAuth } from "Authentication";
import { useRoutes } from "Routes";

import { AppBase } from "Pages";
import { Menu, Card } from "Components";

export default function AppMenu(props) {
  const { base } = props;
  const buttons = useAppMenu(base);
  const { userType } = useAuth();
  return (
    <AppBase title="Menu" heading={`${userType} Functionality`}>
      <Card style={{ maxWidth: 600 }}>
        <Menu buttons={buttons} />
      </Card>
    </AppBase>
  );
}
AppMenu.displayName = "AppMenu";

function useAppMenu(base) {
  const { isAdmin, isManager, isCustomer } = useAuth();
  const routes = useRoutes({ isAdmin, isManager, isCustomer });
  return useMemo(() => routes.map(b => ({ ...b, to: base + b.to })), [
    routes,
    base
  ]);
}
