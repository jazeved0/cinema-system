import React from "react";
import { isArray, isDefined } from "Utility";

import { Redirect as RouterRedirect} from "react-router-dom";

export default function Redirect(props) {
  const { from, to, when, ...rest } = props;
  if (isDefined(when) && !when) return null;
  else {
    return isArray(from) ? (
      from.map(f => <RouterRedirect from={f} key={f} to={to} {...rest} />)
    ) : (
      <RouterRedirect from={from} to={to} {...rest} />
    );
  }
}
