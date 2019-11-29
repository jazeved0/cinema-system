import React from "react";
import { Page } from "Components";

export default function NotFound(props) {
  return (
    <Page title="Not Found">
      <h1 className="intro-space">
        Page Not Found{" "}
        <span role="img" aria-label="">
          😕
        </span>
      </h1>
      <p className="lead">Status code 404</p>
      <hr className="hr-short" />
      <p>
        Sorry, we can’t find that page. It might be an old link or maybe it
        moved.
      </p>
    </Page>
  );
}
NotFound.displayName = "NotFound";
