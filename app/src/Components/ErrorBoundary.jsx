import React from "react";
import PropTypes from "prop-types";
import { warn, isDefined } from "Utility";

export default class ErrorBoundary extends React.Component {
  constructor(props) {
    super(props);
    this.state = { hasError: false };
  }

  static getDerivedStateFromError() {
    return { hasError: true };
  }

  static propTypes = {
    onError: PropTypes.func,
    children: PropTypes.oneOfType([
      PropTypes.arrayOf(PropTypes.node),
      PropTypes.node
    ]).isRequired,
    fallback: PropTypes.oneOfType([
      PropTypes.arrayOf(PropTypes.node),
      PropTypes.node
    ])
  };

  static defaultProps = {
    onError() {}
  };

  static displayName = "ErrorBoundary";

  componentDidCatch(error, info) {
    warn(error, info);
    if (isDefined(this.props.onError)) this.props.onError(error, info);
  }

  render() {
    const { fallback, children } = this.props;
    if (this.state.hasError) {
      return isDefined(fallback) ? fallback : null;
    } else return children;
  }
}
