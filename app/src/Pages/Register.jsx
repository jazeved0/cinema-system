import React from "react";
import { Col } from "react-bootstrap";
import { Card, Link } from "Components";

export default function Register() {
  return (
    <div className="register">
      <h1 className="intro-space">Register</h1>
      <p className="lead">Select registration type</p>
      <Card style={{ maxWidth: 600 }}>
        <div className="register--buttons">
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/user">User Only</Link>
          </Col>
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/customer">Customer Only</Link>
          </Col>
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/manager">Manager Only</Link>
          </Col>
          <Col sm={6}>
            <Link className="btn btn-primary" href="/register/manager-customer">Manager-Customer</Link>
          </Col>
        </div>
      </Card>
    </div>
  );
}
Register.displayName = "Register";
