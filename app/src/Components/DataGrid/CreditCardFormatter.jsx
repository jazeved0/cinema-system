import React from "react";
import { formatCreditCard } from "Utility";

import { CreditCardDisplay } from "Components";

export default function CreditCardFormatter({ value }) {
  return <CreditCardDisplay text={formatCreditCard(value)} />;
}
CreditCardFormatter.displayName = "CreditCardFormatter";
