import React from "react";
import PropTypes from "prop-types";
import classNames from "classnames";
import { useRouteMatch } from "react-router";
import { isExternal, isFile, isNil, isDefined, isEmptyOrNil } from "Utility";

import { Link as RouterLink } from "react-router-dom";
import { Icon } from "Components";

// Link that automatically resolves to either a standard HTML <a> tag or a
// react-router Link component for external/internal links
function Link({
  href,
  disabled,
  newTab,
  icon,
  text,
  download,
  partiallyActive,
  ...props
}) {
  const className = classNames(props.className, props.class);
  const external = isExternal(href);
  const onClick = props.onClick || resolveAction(props.action);
  const useAnchor =
    external ||
    isFile(href) ||
    newTab ||
    href.indexOf("#") !== -1 ||
    href.indexOf("?") !== -1;
  const customChildren = isDefined(props.children);

  const derivedProps = {
    // determine children prop
    ...(customChildren
      ? { children: props.children }
      : { children: <LinkContent text={text} icon={icon} /> }),
    // anchor props
    ...(useAnchor
      ? {
          rel: external ? "noopener noreferrer" : null,
          target: newTab || (external && isNil(newTab)) ? "_blank" : null
        }
      : {}),
    // merge class names
    className: classNames(className, { disabled }),
    // add in other props
    "aria-label": props.ariaLabel
  };

  const targetNewTab = newTab === true || (external && newTab !== false);
  if (targetNewTab) props.target = "_blank";
  if (external) props.rel = "noopener";

  return useAnchor ? (
    // eslint-disable-next-line jsx-a11y/anchor-has-content
    <a href={href} download={download} onClick={onClick} {...derivedProps} />
  ) : (
    <RouterLinkWrapper
      to={href}
      activeClassName="active-link"
      partialClassName="partially-active-link"
      usePartiallyActive={partiallyActive}
      {...derivedProps}
    />
  );
}

export default Link;

Link.propTypes = {
  // Props from schema
  href: PropTypes.string,
  text: PropTypes.string,
  icon: PropTypes.string,
  class: PropTypes.string,
  action: PropTypes.oneOfType([PropTypes.string, PropTypes.func]),
  newTab: PropTypes.bool,
  disabled: PropTypes.bool,
  download: PropTypes.bool,
  ariaLabel: PropTypes.string,
  // Additional props
  className: PropTypes.string,
  onClick: PropTypes.func,
  children: PropTypes.oneOfType([
    PropTypes.node,
    PropTypes.arrayOf(PropTypes.node)
  ]),
  partiallyActive: PropTypes.bool
};

Link.defaultProps = {
  disabled: false,
  href: "",
  icon: "",
  text: "",
  download: false,
  partiallyActive: true
};

Link.displayName = "Link";

// Predefined onClick action map
export const actions = {
  back: () => {
    window.history.go(-1);
    return false;
  }
};

// Resolves an action prop to the onClick function callback
function resolveAction(action) {
  if (typeof action === "string") {
    return actions[action];
  } else return action;
}

// ? ================
// ? Helper component
// ? ================

function LinkContent({ text, icon }) {
  return (
    <>
      {isEmptyOrNil(text) ? null : <span>{text}</span>}
      {isEmptyOrNil(icon) ? null : <Icon name={icon} />}
    </>
  );
}

LinkContent.displayName = "LinkContent";

function RouterLinkWrapper({
  to,
  className,
  activeClassName,
  partialClassName,
  usePartiallyActive,
  ...rest
}) {
  const partialMatch = useRouteMatch({ path: to, exact: false });
  const fullMatch = useRouteMatch({ path: to, exact: true });
  const isPartial = isNil(fullMatch) && isDefined(partialMatch);
  const isFull = isDefined(fullMatch);
  const derivedClassName = classNames(
    className,
    usePartiallyActive
      ? {
          [activeClassName]: isFull,
          [partialClassName]: isPartial
        }
      : {
          [activeClassName]: isFull || isPartial
        }
  );
  return <RouterLink to={to} className={derivedClassName} {...rest} />;
}

RouterLinkWrapper.displayName = "RouterLinkWrapper";
