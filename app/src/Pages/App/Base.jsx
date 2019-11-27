import React from "react";
import { isDefined } from "Utility";

import { Page } from "Components";
import { Container } from "react-bootstrap";

export default function AppBase(props) {
  const { title, fullWidth, children, heading } = props;
  return (
    <Page title={title} noContainer>
      <Container fluid={fullWidth}>
        <h1 className="intro-space">{isDefined(heading) ? heading : title}</h1>
        {children}
      </Container>
    </Page>
  );
}
AppBase.displayName = "AppBase";
