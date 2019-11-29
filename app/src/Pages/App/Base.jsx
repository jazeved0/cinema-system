import React from "react";
import { isDefined, capitalize } from "Utility";

import { Page } from "Components";
import { Container, Badge } from "react-bootstrap";

export default function AppBase(props) {
  const { title, fullWidth, children, heading, level } = props;
  return (
    <Page title={title} noContainer>
      <Container fluid={fullWidth} className="app-base">
        <div className="app-space">
          {level && (
            <h3 className="level-badge-header">
              <Badge className={`level-badge badge__${level}`}>
                {capitalize(level)}
              </Badge>
            </h3>
          )}
          <h1>{isDefined(heading) ? heading : title}</h1>
        </div>
        {children}
      </Container>
    </Page>
  );
}
AppBase.displayName = "AppBase";
