import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import { isDefined } from "Utility";

import ReactSwitch from "react-switch";

import { lightColor, primaryColor } from "global.json";

export default function Switch({ label, className, onChange, checked, ...rest }) {
  return (
    <span className={classNames("switch", className)}>
      <ReactSwitch
        className="react-switch"
        activeBoxShadow="0px 0px 1px 10px rgba(0, 0, 0, 0.2)"
        boxShadow="0px 1px 5px rgba(0, 0, 0, 0.6)"
        offHandleColor={lightColor}
        onHandleColor={lightColor}
        onColor={primaryColor}
        uncheckedIcon={false}
        checkedIcon={false}
        aria-label={label}
        height={24}
        width={48}
        onChange={onChange}
        checked={checked}
        {...rest}
      />
      {isDefined(label) ? <span className="label" children={label} /> : null}
    </span>
  );
}

Switch.propTypes = {
  label: PropTypes.string,
  className: PropTypes.string,
  onChange: PropTypes.func,
  checked: PropTypes.bool
};
Switch.defaultProps = {
  label: null,
  onChange() {},
  className: "",
  checked: false
};
Switch.displayName = "Switch";
