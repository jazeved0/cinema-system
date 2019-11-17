import React from "react";
import creditCardType from "credit-card-type";

import visa from "payment-icons/min/single/visa.svg";
import amex from "payment-icons/min/single/amex.svg";
import diners from "payment-icons/min/single/diners.svg";
import discover from "payment-icons/min/single/discover.svg";
import elo from "payment-icons/min/single/elo.svg";
import hipercard from "payment-icons/min/single/hipercard.svg";
import jcb from "payment-icons/min/single/jcb.svg";
import maestro from "payment-icons/min/single/maestro.svg";
import mastercard from "payment-icons/min/single/mastercard.svg";
import unionpay from "payment-icons/min/single/unionpay.svg";

// ? ==============
// ? Sub-components
// ? ==============

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

  let icon = null;
  const isSupported = ccTypes.hasOwnProperty(ccType);
  if (isSupported) icon = ccTypes[ccType];

  return (
    <div className="credit-card-display">
      {isSupported && (
        <img
          className="credit-card-display--icon"
          aria-label={label}
          alt={label}
          src={icon}
        />
      )}
      {text}
    </div>
  );
}
CreditCardDisplay.displayName = "CreditCardDisplay";
