import React from "react";
import { Navbar } from "react-bootstrap";
import { useRouteMatch } from "react-router-dom";

export default function SecondaryNav() {
  const rootMatch = useRouteMatch({
    path: "/",
    exact: true
  });
  const match = useRouteMatch({
    path: "/",
    exact: false
  });
  return match && !rootMatch ? (
    <Navbar bg="primary" variant="dark" className="secondary-nav">
      <Navbar.Brand href="/" className="brand">
        <Icon name="film" className="brand--icon" />
        <h1 className="brand--text">Cinema System</h1>
      </Navbar.Brand>

      <div className="right-buttons">
        <Link
          href="https://github.com/jazevedo620/cs4400-team20"
          ariaLabel="Github"
        >
          <Icon name="github" />
        </Link>
      </div>
    </Navbar>
  ) : null;
}
