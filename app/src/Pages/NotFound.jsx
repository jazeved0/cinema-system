import React from "react";

export default function NotFound(props) {
  return (
    <>
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
    </>
  );
}
NotFound.displayName = "NotFound";
