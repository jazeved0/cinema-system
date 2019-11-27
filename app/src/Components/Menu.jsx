import React from "react";
import classNames from "classnames";

import { Col } from "react-bootstrap";
import { Link } from "Components";

export default function Menu(props) {
  const { buttons, className } = props;
  return (
    <div className={classNames("menu", className)}>
      {buttons.map(({ to, text }) => (
        <Col sm={6} key={to}>
          <Link className="btn btn-primary" href={to}>
            {text}
          </Link>
        </Col>
      ))}
    </div>
  );
}
Menu.displayName = "Menu";
