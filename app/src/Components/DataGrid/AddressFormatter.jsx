import React from "react";

export default function AddressFormatter({
  row: { street, city, state, zipcode }
}) {
  return (
    <div className="address-display">
      {`${street}, ${city}, ${state} ${zipcode}`}
    </div>
  );
}
AddressFormatter.displayName = "AddressFormatter";
