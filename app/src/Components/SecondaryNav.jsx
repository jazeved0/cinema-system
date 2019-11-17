import React, { useCallback, useContext } from "react";
import { useRouteMatch, useHistory } from "react-router-dom";
import { splitPath, isDefined } from "Utility";

import { Navbar, Button } from "react-bootstrap";
import { Icon, Layout } from "Components";

export default function SecondaryNav() {
  // Exact & partial root match
  const isRoot = isDefined(
    useRouteMatch({
      path: "/",
      exact: true
    })
  );

  // Go up one level on back button press
  const history = useHistory();
  const onBack = useCallback(() => {
    const splitUrl = splitPath(history.location.pathname);
    const newUrl = `/${splitUrl.slice(0, -1).join("/")}`;
    history.push(newUrl);
  }, [history]);

  // Get dark mode status
  const isDarkMode = useContext(Layout.DarkMode);

  return !isRoot ? (
    <Navbar variant="dark" className="secondary-nav">
      <Button
        variant={isDarkMode ? "primary" : "light"}
        ariaLabel="Go back"
        className="secondary-nav--back"
        onClick={onBack}
      >
        <Icon name="chevronLeft" />
        <span className="secondary-nav--back-text">Back</span>
      </Button>
    </Navbar>
  ) : null;
}
SecondaryNav.displayName = "SecondaryNav";
