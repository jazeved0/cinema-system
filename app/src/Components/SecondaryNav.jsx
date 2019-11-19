import React from "react";
import { useRouteMatch } from "react-router-dom";
import { isDefined } from "Utility";

import { Navbar } from "react-bootstrap";
import { BackButton } from "Components";

export default function SecondaryNav() {
  // Exact & partial root match
  const isRoot = isDefined(
    useRouteMatch({
      path: "/",
      exact: true
    })
  );

  return !isRoot ? (
    <Navbar variant="dark" className="secondary-nav">
      <BackButton responsive />
    </Navbar>
  ) : null;
}
SecondaryNav.displayName = "SecondaryNav";
