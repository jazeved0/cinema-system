import React, { forwardRef } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import { Icon } from "Components";
import { InputGroup, FormControl, Button } from "react-bootstrap";

const NumericUpDown = forwardRef(
  (
    {
      isValid,
      isInvalid,
      onChange,
      onUp,
      onDown,
      value,
      placeholder,
      disabled,
      ...rest
    },
    ref
  ) => {
    return (
      <InputGroup
        className={classNames("numeric-up-down", {
          "is-invalid": isInvalid,
          "is-valid": isValid,
          disabled
        })}
      >
        <FormControl
          placeholder={placeholder}
          value={value}
          onChange={onChange}
          isValid={isValid}
          isInvalid={isInvalid}
          type="text"
          ref={ref}
          disabled={disabled}
          {...rest}
        />
        <InputGroup.Append>
          <Button variant="input-control" onClick={onDown} disabled={disabled}>
            <Icon name="minus" />
          </Button>
          <Button variant="input-control" onClick={onUp} disabled={disabled}>
            <Icon name="plus" />
          </Button>
        </InputGroup.Append>
      </InputGroup>
    );
  }
);

export default NumericUpDown;

NumericUpDown.propTypes = {
  isValid: PropTypes.bool,
  isInvalid: PropTypes.bool,
  onChange: PropTypes.func,
  onUp: PropTypes.func,
  onDown: PropTypes.func,
  value: PropTypes.string,
  placeholder: PropTypes.string
};
NumericUpDown.defaultProps = {
  isValid: false,
  isInvalid: false,
  onChange() {},
  onUp() {},
  onDown() {},
  placeholder: ""
};
NumericUpDown.displayName = "NumericUpDown";
