import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import { FontAwesomeIcon } from "@fortawesome/react-fontawesome";
import { config } from "@fortawesome/fontawesome-svg-core";
import { resolveIcon } from "./loader";

config.autoAddCss = false;
const baseStyle = { display: "inline-block", width: "1em" };

// Embeds a FontAwesome SVG inline icon into the page, optionally allowing for
// custom icon definitions in ./custom.js
function Icon({ className, name, prefix, style, noAutoWidth, ...rest }) {
  return (
    <span
      className={classNames(className, "icon")}
      style={noAutoWidth ? style : { ...baseStyle, ...style }}
    >
      <FontAwesomeIcon icon={resolveIcon(name, prefix)} {...rest} />
    </span>
  );
}

export default Icon;

Icon.propTypes = {
  className: PropTypes.string,
  name: PropTypes.string.isRequired,
  style: PropTypes.object,
  noAutoWidth: PropTypes.bool,
  prefix: PropTypes.string
};

Icon.defaultProps = {
  className: "",
  name: "chevron-right",
  style: {},
  noAutoWidth: false
};

Icon.displayName = "Icon";
