import React from "react";
import PropTypes from "prop-types";
import { isDefined, isNil, formatDate, parseDate } from "Utility";

import { DatePicker } from "Components";

export default class DateFilter extends React.Component {
  constructor(props) {
    super(props);
    this.handleChangeMin = this.handleChangeMin.bind(this);
    this.handleChangeMax = this.handleChangeMax.bind(this);
    this.state = { min: null, max: null };
  }

  filterValues(row, { filterTerm }, columnKey) {
    const rawValue = row[columnKey];
    if (isNil(rawValue)) return false;
    const date = parseDate(rawValue);
    return filterTerm.every(({ mode, value }) => {
      const equal =
        date.getTime() === value.getTime() ||
        formatDate(date) === formatDate(value);
      if (equal) return true;
      else if (mode === "min") return date > value;
      else return date < value;
    });
  }

  calculateFilters({ min, max }) {
    let filters = [];
    if (isDefined(min)) filters.push({ mode: "min", value: min });
    if (isDefined(max)) filters.push({ mode: "max", value: max });
    return filters;
  }

  handleChangeMin(value) {
    this.setState({ min: value });
    this.props.onChange({
      filterTerm: this.calculateFilters({ ...this.state, min: value }),
      column: this.props.column,
      filterValues: this.filterValues
    });
  }

  handleChangeMax(value) {
    this.setState({ max: value });
    this.props.onChange({
      filterTerm: this.calculateFilters({ ...this.state, max: value }),
      column: this.props.column,
      filterValues: this.filterValues
    });
  }

  render() {
    const { column } = this.props;
    return (
      <div>
        <div className="form-group date-filter">
          <DatePicker
            onChange={this.handleChangeMin}
            placeholderText={`Minimum ${column.name}`}
            withPortal
            isClearable
            selected={this.state.min}
            noIcon
          />
          <DatePicker
            onChange={this.handleChangeMax}
            placeholderText={`Maximum ${column.name}`}
            withPortal
            isClearable
            selected={this.state.max}
            noIcon
          />
        </div>
      </div>
    );
  }
}

DateFilter.propTypes = {
  onChange: PropTypes.func.isRequired,
  column: PropTypes.object
};
DateFilter.displayName = "DateFilter";
