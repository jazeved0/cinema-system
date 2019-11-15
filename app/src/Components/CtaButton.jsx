import React from "react";
import classNames from "classnames";

import { Button } from "react-bootstrap";
import { Icon } from "Components";

export default function CtaButton(props) {
  const {
    icon,
    iconProps,
    children,
    variant,
    className,
    animated,
    reversed,
    glowing,
    content,
    ...rest
  } = props;
  return (
    <Button
      variant={variant}
      className={classNames("cta-button", className, {
        "cta-button__animated": animated,
        "cta-button__reversed": reversed,
        "cta-button__glowing": glowing
      })}
      {...rest}
    >
      <div className="cta-button--content-wrapper">
        <div className="cta-button--content">
          <span className="cta-button--text">{children}</span>
          <Icon className="cta-button--icon" name={icon} {...iconProps} />
        </div>
      </div>
      {content}
    </Button>
  );
}
