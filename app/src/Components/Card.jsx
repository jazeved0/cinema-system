import React from "react";

export default function Card(props) {
  const { children, ...rest } = props;
  return (
    <div className="card" {...rest}>
      {children}
    </div>
  );
}
Card.displayName = "Card";
