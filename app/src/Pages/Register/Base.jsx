import React from "react";
import classNames from "classnames";

import { Page, BackButton } from "Components";

export default function Base(props) {
  const { title, children, name } = props;
  return (
    <Page title={title} noContainer>
      <div className={classNames("register", name && `register-${name}`)}>
        <BackButton primary />
        <h1>{title}</h1>
        {children}
      </div>
    </Page>
  );
}
Base.displayName = "Base";
