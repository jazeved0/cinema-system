import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import { Icon, Tooltip } from "Components";

export default function HelpTooltip({
  content,
  top,
  right,
  left,
  className,
  style,
  ...rest
}) {
  return (
    <Tooltip
      text={content}
      top={top}
      left={left}
      bottom={!top && !right && !left}
      {...rest}
    >
      <span className={classNames("help-tooltip", className)} style={style}>
        <Icon name="question-circle" size="lg" />
      </span>
    </Tooltip>
  );
}

HelpTooltip.propTypes = {
  content: PropTypes.oneOfType([
    PropTypes.node,
    PropTypes.arrayOf(PropTypes.node)
  ]).isRequired,
  top: PropTypes.bool,
  right: PropTypes.bool,
  left: PropTypes.bool,
  className: PropTypes.string,
  style: PropTypes.object
};
HelpTooltip.defaultProps = {
  top: false,
  right: false,
  left: false,
  className: "",
  style: {}
};
HelpTooltip.displayName = "HelpTooltip";
