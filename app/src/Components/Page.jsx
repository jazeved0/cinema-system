import React from "react";
import { isDefined } from "Utility";

import { Container } from "react-bootstrap";
import Helmet from "react-helmet";

const siteTitle = "Cinema System";
export default function Page(props) {
  const { title, children, noContainer } = props;
  const fullTitle = isDefined(title) ? `${title} | ${siteTitle}` : siteTitle;
  return (
    <>
      <Helmet
        title={fullTitle}
        meta={[
          {
            property: "og:title",
            content: fullTitle
          }
        ]}
      />
      {noContainer ? children : <Container>{children}</Container>}
    </>
  );
}
Page.displayName = "Page";
