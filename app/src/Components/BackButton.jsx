import React, { useCallback, useContext } from "react";
import { useHistory } from "react-router-dom";
import classNames from "classnames";
import { splitPath } from "Utility";

import { Button } from "react-bootstrap";
import { Icon, Layout } from "Components";

export default function BackButton(props) {
  const { responsive, primary } = props;

  // Go up one level on back button press
  const history = useHistory();
  const onBack = useCallback(() => {
    const splitUrl = splitPath(history.location.pathname);
    const newUrl = `/${splitUrl.slice(0, -1).join("/")}`;
    history.push(newUrl);
  }, [history]);

  // Get dark mode status
  const isDarkMode = useContext(Layout.DarkMode);

  return (
    <Button
      variant={primary || isDarkMode ? "primary" : "light"}
      ariaLabel="Go back"
      className={classNames("back-button", { responsive, primary })}
      onClick={onBack}
    >
      <Icon name="chevronLeft" />
      <span className="back-button--text">Back</span>
    </Button>
  );
}
BackButton.displayName = "BackButton";
