import React from "react";

import { Card, Menu } from "Components";
import { RegisterBase } from "Pages";

export default function RegisterMenu() {
  return (
    <RegisterBase title="Register" name="menu">
      <p className="lead">Select registration type</p>
      <Card style={{ maxWidth: 600 }}>
        <Menu
          buttons={[
            { to: "/register/user", text: "User Only" },
            { to: "/register/customer", text: "Customer Only" },
            { to: "/register/manager", text: "Manager Only" },
            { to: "/register/manager-customer", text: "Manager-Customer" }
          ]}
        />
      </Card>
    </RegisterBase>
  );
}
RegisterMenu.displayName = "RegisterMenu";
