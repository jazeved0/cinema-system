import React, { useCallback } from "react";
import PropTypes from "prop-types";
import classNames from "classnames";

import { Button } from "react-bootstrap";
import { Icon } from "Components";

export default function SetInput(props) {
  const {
    items,
    addItem,
    removeItem,
    renderItem,
    children,
    addDisabled,
    disabled,
    className
  } = props;

  return (
    <div className={classNames("set-input", className, { disabled })}>
      <div className="set-input--items-pane">
        {items.map((item, i) => (
          <SetInput.Item
            key={item}
            index={i}
            onRemove={removeItem}
            children={renderItem(item)}
          />
        ))}
      </div>
      <div className="set-input--input">
        {children}
        <Button
          variant="input-control"
          className="set-input--add"
          onClick={addItem}
          onMouseDown={e => {
            if (e) {
              e.preventDefault();
            }
          }}
          onKeyUp={e => {
            if (e.keyCode === 13 || e.keyCode === 32) {
              addItem();
            }
          }}
          disabled={addDisabled}
        >
          <Icon name="plus" />
        </Button>
      </div>
    </div>
  );
}
SetInput.propTypes = {
  items: PropTypes.array,
  addItem: PropTypes.func,
  removeItem: PropTypes.func,
  renderItem: PropTypes.func,
  children: PropTypes.oneOfType([
    PropTypes.node,
    PropTypes.arrayOf(PropTypes.node)
  ]),
  disabled: PropTypes.bool,
  addDisabled: PropTypes.bool,
  className: PropTypes.string
};
SetInput.defaultProps = {
  items: [],
  addItem() {},
  removeItem() {},
  renderItem: item => <div>{String(item)}</div>,
  disabled: false,
  addDisabled: false,
  className: ""
};
SetInput.displayName = "SetInput";

// ? ==============
// ? Sub-components
// ? ==============

SetInput.Item = function({ index, onRemove, children }) {
  // CRA throws error due to "nested" component declaration
  /* eslint-disable react-hooks/rules-of-hooks */

  return (
    <button
      className="set-input--item"
      type="button"
      onClick={useCallback(() => {
        onRemove(index);
      }, [index, onRemove])}
    >
      {children}
      <div className="set-input--remove">
        <Icon name="times-circle" />
      </div>
    </button>
  );
};
SetInput.Item.propTypes = {
  index: PropTypes.number.isRequired,
  onRemove: PropTypes.func.isRequired,
  children: PropTypes.oneOfType([
    PropTypes.arrayOf(PropTypes.node),
    PropTypes.node
  ]).isRequired
};
