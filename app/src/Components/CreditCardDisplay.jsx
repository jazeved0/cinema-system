import React from "react";
import creditCardType from "credit-card-type";

import { ReactComponent as visa } from "payment-icons/min/flat/visa.svg";
import { ReactComponent as amex } from "payment-icons/min/flat/amex.svg";
import { ReactComponent as diners } from "payment-icons/min/single/diners.svg";
import { ReactComponent as discover } from "payment-icons/min/single/discover.svg";
import { ReactComponent as elo } from "payment-icons/min/single/elo.svg";
import { ReactComponent as hipercard } from "payment-icons/min/flat/hipercard.svg";
import { ReactComponent as jcb } from "payment-icons/min/single/jcb.svg";
import { ReactComponent as maestro } from "payment-icons/min/single/maestro.svg";
import { ReactComponent as mastercard } from "payment-icons/min/single/mastercard.svg";
import { ReactComponent as unionpay } from "payment-icons/min/single/unionpay.svg";

const ccTypes = {
  visa,
  mastercard,
  jcb,
  unionpay,
  discover,
  dinersclub: diners,
  "american-express": amex,
  hipercard,
  elo,
  maestro
};
export default function CreditCardDisplay(props) {
  const { text } = props;
  const match = creditCardType(text.replace(/\D/g, ""));
  let ccType = "";
  let label = "";
  if (match.length > 0) {
    ccType = match[0].type;
    label = match[0].niceType;
  }

  let Icon = null;
  const isSupported = ccTypes.hasOwnProperty(ccType);
  if (isSupported) Icon = ccTypes[ccType];

  return (
    <div className="credit-card-display">
      {isSupported && (
        <span
          className="credit-card-display--icon"
          aria-label={label}
          alt={label}
          children={<Icon />}
        />
      )}
      <span className="credit-card-display--text">{text}</span>
    </div>
  );
}
CreditCardDisplay.displayName = "CreditCardDisplay";
