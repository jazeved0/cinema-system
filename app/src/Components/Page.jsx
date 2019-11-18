import React from "react";
import { isDefined } from "Utility";

import Helmet from "react-helmet";

const siteTitle = "Cinema System";
export default function Page(props) {
  const { title, children } = props;
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
      {children}
    </>
  );
}
Page.displayName = "Page";
