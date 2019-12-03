import React from "react";
import { useDarkMode } from "Utility";
import { useAuth } from "Authentication";

import { Navbar } from "react-bootstrap";
import { Icon, Link, SessionButton } from "Components";

export default function Layout({ children }) {
  // Dark/light theme selection
  const { value, toggle } = useDarkMode(true);
  const { isAuthenticated } = useAuth();

  return (
    <div className="layout">
      <Layout.DarkMode.Provider value={value}>
        <Navbar
          bg="primary"
          variant="dark"
          className="layout--nav"
          sticky="top"
        >
          <Navbar.Brand as={Link} href="/" className="brand">
            <Icon name="film" className="brand--icon" />
            <h1 className="brand--text">Cinema System</h1>
          </Navbar.Brand>

          <div className="right-buttons">
            {isAuthenticated ? (
              <>
                <SessionButton />
                <span className="nav-divider" />
              </>
            ) : null}
            <Link
              href="https://github.com/jazevedo620/cs4400-team20"
              ariaLabel="Github"
            >
              <Icon name="github" />
            </Link>
            <span className="nav-divider" />
            <button
              className="dark-mode-button"
              onClick={toggle}
              aria-label="Toggle dark mode"
            >
              {!value && <Icon name="sun" />}
              {value && <Icon name="moon" />}
            </button>
          </div>
        </Navbar>
        <main>{children}</main>
      </Layout.DarkMode.Provider>
    </div>
  );
}
Layout.displayName = "Layout";
Layout.DarkMode = React.createContext(true);
