import React from "react";

import { Col } from "react-bootstrap";
import { Card, Link } from "Components";
import { RegisterBase } from "Pages";

export default function Menu() {
  return (
    <RegisterBase title="Register" name="menu">
      <p className="lead">Select registration type</p>
      <Card style={{ maxWidth: 600 }}>
        <div className="register-menu--buttons">
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/user">
              User Only
            </Link>
          </Col>
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/customer">
              Customer Only
            </Link>
          </Col>
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/manager">
              Manager Only
            </Link>
          </Col>
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/manager-customer">
              Manager-Customer
            </Link>
          </Col>
        </div>
      </Card>
    </RegisterBase>
  );
}
Menu.displayName = "Menu";
