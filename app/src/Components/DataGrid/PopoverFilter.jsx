import React, { useCallback, useMemo } from "react";
import PropTypes from "prop-types";
import {
  isDefined,
  identity,
  isNil,
  states,
  constructMap,
  isEmptyOrNil,
  formatDate,
  parseDate
} from "Utility";

import { SetInput, Form } from "Components";
import {
  Popover,
  InputGroup,
  OverlayTrigger,
  Button,
  Form as BootstrapForm
} from "react-bootstrap";
import { placeholderFormats, calculateInitialState } from "Components/Form";

export default class PopoverFilter extends React.Component {
  constructor(props) {
    super(props);
    this.handleFilterChange = this.handleFilterChange.bind(this);
    this.removeFilter = this.removeFilter.bind(this);
    this.state = { filters: [] };
  }

  // Applies every application function to the row, passing if and
  // only if it passes every filter
  filterValues(row, { filterTerm }, columnKey) {
    return filterTerm.every(({ apply, value }) => apply(row, value, columnKey));
  }

  removeFilter(index) {
    const { filters } = this.state;
    this.handleFilterChange(filters.filter((_, i) => index !== i));
  }

  handleFilterChange(newFilters) {
    // Support lazy calculation
    if (typeof newFilters === "function") {
      newFilters = newFilters(this.state.filters);
    }

    this.setState({ filters: newFilters });
    this.props.onChange({
      filterTerm: newFilters,
      column: this.props.column,
      filterValues: this.filterValues
    });
  }

  render() {
    const { column } = this.props;
    const { filters } = this.state;
    const { popoverFilter: Filter } = column;
    const isEmpty = filters.length === 0;

    return (
      <div className="popover-filter">
        <div className="form-group">
          <InputGroup>
            <div className="popover-filter__items">
              {isEmpty && (
                <div className="popover-filter__items-placeholder">
                  <p>Add a filter</p>
                </div>
              )}
              <SetInput.Items
                items={filters.map(({ label }) => label)}
                onRemove={this.removeFilter}
              />
            </div>
            <InputGroup.Append>
              <OverlayTrigger
                trigger="click"
                placement="bottom"
                rootClose
                overlay={
                  <Popover className="popover-filter__popover">
                    <Popover.Title>Edit filter</Popover.Title>
                    <Popover.Content>
                      {isDefined(Filter) && (
                        <Filter
                          filters={filters}
                          onChange={this.handleFilterChange}
                        />
                      )}
                    </Popover.Content>
                  </Popover>
                }
              >
                <Button
                  variant="outline-primary"
                  className="popover-filter__button"
                >
                  Filter
                </Button>
              </OverlayTrigger>
            </InputGroup.Append>
          </InputGroup>
        </div>
      </div>
    );
  }
}

PopoverFilter.propTypes = {
  onChange: PropTypes.func.isRequired,
  column: PropTypes.object
};
PopoverFilter.displayName = "PopoverFilter";

// ? ================
// ? Built-in filters
// ? ================

PopoverFilter.Address = function({ filters, onChange }) {
  /* eslint-disable react-hooks/rules-of-hooks */
  const simpleApply = key => (row, value) => {
    if (isEmptyOrNil(value)) return true;
    if (row[key].toLowerCase().indexOf(value) !== -1) {
      return true;
    } else return false;
  };
  const entries = [
    {
      key: "street",
      name: "Street",
      type: "text",
      apply: simpleApply("street")
    },
    {
      key: "city",
      name: "City",
      type: "text",
      apply: simpleApply("city")
    },
    {
      key: "state",
      name: "State",
      type: "combo",
      props: { options: states },
      apply: (row, value) => isNil(value) || row.state === value.value,
      makeLabel: value => `State: ${value.value}`
    },
    {
      key: "zipcode",
      name: "Zipcode",
      type: "text",
      processValue: value => {
        const numeric = value.replace(/\D/g, "");
        return numeric;
      },
      apply: simpleApply("zipcode")
    }
  ];

  // Key => Entry map
  const entriesMap = useMemo(() => constructMap(entries), [entries]);

  // Pass input changes to filters
  const onChangeInputs = useCallback(
    (key, event) => {
      const { makeLabel, apply, name } = entriesMap[key];
      let processFunc = entriesMap[key].processValue;
      if (isNil(processFunc)) processFunc = identity;
      const newValue =
        isDefined(event) && isDefined(event.target)
          ? event.target.value
          : event;
      onChange(f => {
        if (isEmptyOrNil(newValue)) {
          // Remove filter
          return f.filter(filter => filter.key !== key);
        } else {
          // Add or update filter
          const label = isDefined(makeLabel)
            ? makeLabel(newValue)
            : `${name}: ${newValue}`;
          const newFilter = {
            value: newValue,
            label,
            apply,
            key
          };
          const oldFilter = f.find(({ key: k }) => k === key);
          if (isDefined(oldFilter)) {
            // Update filter
            return f.map(filter => (filter.key === key ? newFilter : filter));
          } else {
            // Add filter
            return [...f, newFilter];
          }
        }
      });
    },
    [entriesMap, onChange]
  );
  const inputs = entries.map((entry, i) => {
    const format = entry.type || "text";
    const placeholder = placeholderFormats.hasOwnProperty(format)
      ? placeholderFormats[format]
      : placeholderFormats["text"];
    const filter = filters.find(f => f.key === entry.key);
    const value = isDefined(filter)
      ? filter.value
      : calculateInitialState(entries)[entry.key];
    return (
      <>
        <Form.Input
          type={format}
          inputKey={entry.key}
          placeholder={placeholder(entry)}
          onChange={onChangeInputs}
          value={value}
          onBlur={identity}
          onKeyDown={identity}
          {...entry.props}
        />
        {isDefined(entry.info) ? (
          <BootstrapForm.Text className="text-muted">
            {entry.info}
          </BootstrapForm.Text>
        ) : null}
      </>
    );
  });

  return (
    <div className="address-filter">
      <BootstrapForm noValidate className="_form horizontal">
        <table className="address-filter__table">
          <tbody>
            {entries.map((entry, i) => (
              <BootstrapForm.Group
                key={entry.key}
                as="tr"
                controlId={`address-filter__${entry.key}`}
              >
                <td>
                  <BootstrapForm.Label>{entry.name}</BootstrapForm.Label>
                </td>
                <td>{inputs[i]}</td>
              </BootstrapForm.Group>
            ))}
          </tbody>
        </table>
      </BootstrapForm>
    </div>
  );
};
PopoverFilter.Address.displayName = "PopoverFilter.Address";

// ! Yes I know this code is duplicated and if I had time I would
// ! refactor it to a Form.Core component but I don't :)
PopoverFilter.Date = function({ filters, onChange }) {
  /* eslint-disable react-hooks/rules-of-hooks */
  const makeLabel = prefix => date => `${prefix} ${formatDate(date)}`;
  const apply = mode => (row, value, columnKey) => {
    if (isNil(value)) return true;
    const rawValue = row[columnKey];
    if (isNil(rawValue)) return false;
    const date = parseDate(rawValue);
    const equal =
      date.getTime() === value.getTime() ||
      formatDate(date) === formatDate(value);
    if (equal) return true;
    else if (mode === "min") return date > value;
    else return date < value;
  };
  const entries = [
    {
      key: "min",
      name: "Minimum",
      type: "date",
      apply: apply("min"),
      makeLabel: makeLabel(">")
    },
    {
      key: "max",
      name: "Maximum",
      type: "date",
      apply: apply("max"),
      makeLabel: makeLabel("<")
    }
  ];

  // Key => Entry map
  const entriesMap = useMemo(() => constructMap(entries), [entries]);

  // Pass input changes to filters
  const onChangeInputs = useCallback(
    (key, event) => {
      const { makeLabel, apply, name } = entriesMap[key];
      let processFunc = entriesMap[key].processValue;
      if (isNil(processFunc)) processFunc = identity;
      const newValue =
        isDefined(event) && isDefined(event.target)
          ? event.target.value
          : event;
      onChange(f => {
        if (isEmptyOrNil(newValue)) {
          // Remove filter
          return f.filter(filter => filter.key !== key);
        } else {
          // Add or update filter
          const label = isDefined(makeLabel)
            ? makeLabel(newValue)
            : `${name}: ${newValue}`;
          const newFilter = {
            value: newValue,
            label,
            apply,
            key
          };
          const oldFilter = f.find(({ key: k }) => k === key);
          if (isDefined(oldFilter)) {
            // Update filter
            return f.map(filter => (filter.key === key ? newFilter : filter));
          } else {
            // Add filter
            return [...f, newFilter];
          }
        }
      });
    },
    [entriesMap, onChange]
  );
  const inputs = entries.map((entry, i) => {
    const format = entry.type || "text";
    const placeholder = placeholderFormats.hasOwnProperty(format)
      ? placeholderFormats[format]
      : placeholderFormats["text"];
    const filter = filters.find(f => f.key === entry.key);
    const value = isDefined(filter)
      ? filter.value
      : calculateInitialState(entries)[entry.key];
    return (
      <>
        <Form.Input
          type={format}
          inputKey={entry.key}
          placeholder={placeholder(entry)}
          onChange={onChangeInputs}
          value={value}
          onBlur={identity}
          onKeyDown={identity}
          {...entry.props}
        />
        {isDefined(entry.info) ? (
          <BootstrapForm.Text className="text-muted">
            {entry.info}
          </BootstrapForm.Text>
        ) : null}
      </>
    );
  });

  return (
    <div className="date-popover-filter">
      <BootstrapForm noValidate className="_form horizontal">
        <table className="address-filter__table">
          <tbody>
            {entries.map((entry, i) => (
              <BootstrapForm.Group
                key={entry.key}
                as="tr"
                controlId={`address-filter__${entry.key}`}
              >
                <td>
                  <BootstrapForm.Label>{entry.name}</BootstrapForm.Label>
                </td>
                <td>{inputs[i]}</td>
              </BootstrapForm.Group>
            ))}
          </tbody>
        </table>
      </BootstrapForm>
    </div>
  );
};
PopoverFilter.Date.displayName = "PopoverFilter.Date";
