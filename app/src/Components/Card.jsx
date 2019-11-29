import React from "react";
import classNames from "classnames";

export default function Card(props) {
  const { children, className, ...rest } = props;
  return (
    <div className={classNames("card", className)} {...rest}>
      {children}
    </div>
  );
}
Card.displayName = "Card";
