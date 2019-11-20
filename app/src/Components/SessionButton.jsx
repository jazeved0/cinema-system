import React from "react";
import { useAuth } from "Authentication";

import { Button, Dropdown } from "react-bootstrap";
import { Icon } from "Components";

export default function SessionButton() {
  const { username, onLogout } = useAuth();
  console.log(onLogout);

  return (
    <Dropdown>
      <Dropdown.Toggle as={Button} className="session-button">
        <span className="session-button__at">@</span>
        <span className="session-button__username">{username}</span>
        <Icon className="session-button__icon" name="caret-down" />
      </Dropdown.Toggle>
      <Dropdown.Menu alignRight>
        <Dropdown.Item onClick={onLogout}>
          <Icon className="session-button__logout-icon" name="signOut" />
          Sign Out
        </Dropdown.Item>
      </Dropdown.Menu>
    </Dropdown>
  );
}
SessionButton.displayName = "SessionButton";
