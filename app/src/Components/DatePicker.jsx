import React from "react";
import classNames from "classnames";

import { Icon } from "Components";
import { InputGroup } from "react-bootstrap";
import { default as ReactDatePicker } from "react-datepicker";

const DatePicker = React.forwardRef((props, ref) => {
  const { isInvalid, className, noIcon, ...rest } = props;
  const component = (
    <ReactDatePicker dateFormat="yyyy-MM-dd" {...rest} ref={ref} />
  );
  return (
    <div
      className={classNames(
        "date-picker",
        { "is-invalid": isInvalid },
        className
      )}
    >
      {noIcon ? (
        component
      ) : (
        <InputGroup>
          {component}
          <InputGroup.Append>
            <InputGroup.Text>
              <Icon name="calendar-alt" />
            </InputGroup.Text>
          </InputGroup.Append>
        </InputGroup>
      )}
    </div>
  );
});

export default DatePicker;

DatePicker.displayName = "DatePicker";
