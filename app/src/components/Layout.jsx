import React from "react";
import { Navbar } from "react-bootstrap";
import { Icon } from "components";
import useDarkMode from "use-dark-mode";

export default function Layout({ children }) {
  // Dark/light theme selection
  const { value, toggle } = useDarkMode(true);

  return (
    <div className="layout">
      <Navbar bg="primary" variant="dark" className="layout--nav">
        <Navbar.Brand href="/" className="brand">
          <Icon name="film" className="brand--icon" />
          <h1 className="brand--text">Cinema System</h1>
        </Navbar.Brand>
        <div className="right-buttons">
          <a
            href="https://github.com/jazevedo620/cs4400-team20"
            rel="noopener noreferrer"
            target="blank"
          >
            <Icon name="github" />
          </a>
          <span className="nav-divider" />
          <button className="dark-mode-button" onClick={toggle}>
            {!value && <Icon name="sun" />}
            {value && <Icon name="moon" />}
          </button>
        </div>
      </Navbar>
      <main>{children}</main>
    </div>
  );
}
