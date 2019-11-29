import React, { useMemo } from "react";
import PropTypes from "prop-types";
import { isDefined, binarySearch, createObject, useMemoRef } from "Utility";

import { Modal, Button } from "react-bootstrap";
import { Form } from "Components";

export default function AddRowModal({
  data,
  show,
  columns,
  onHide,
  onAdd,
  title,
  ...rest
}) {
  // Filter columns based on whether they should have a field
  const relevantColumns = useMemo(
    () => columns.filter(col => col.hasAddField),
    [columns]
  );

  // Memoize sorted unique columns to enable binary search
  const sortedUniqueColumns = useMemoRef(() => {
    // Skip updates if not rendering
    if (!show) return [];

    let uniqueColumns = columns.filter(c => c.unique).map(c => c.key);
    if (uniqueColumns.length === 0) return [];

    let sorted = createObject();
    for (const col of uniqueColumns) {
      sorted[col] = [];
    }
    for (const row of data) {
      for (const col of uniqueColumns) {
        sorted[col].push(row[col]);
      }
    }
    for (const col of uniqueColumns) {
      sorted[col].sort();
    }
    sortedUniqueColumns.current = sorted;
  }, [columns, data, show]);

  // Add uniqueness validator function
  const entries = useMemo(
    () =>
      relevantColumns.map(col => {
        const { unique, validator, key, name } = col;
        if (isDefined(unique) && unique) {
          return {
            ...col,
            validator: args => {
              const { value } = args;
              let index = binarySearch(sortedUniqueColumns.current[key], value);
              if (index !== -1) {
                return {
                  result: false,
                  message: `${name} must be unique`
                };
              }

              if (isDefined(validator)) return validator(value);
            }
          };
        } else return col;
      }),
    [sortedUniqueColumns, relevantColumns]
  );

  return (
    <Modal
      size="lg"
      aria-labelledby="add-row-header"
      centered
      onHide={onHide}
      className="add-row-modal"
      restoreFocus={false}
      scrollable
      show={show}
      {...rest}
    >
      <Modal.Header closeButton>
        <Modal.Title id="add-row-header">
          {isDefined(title) ? title : "Add a new row"}
        </Modal.Title>
      </Modal.Header>
      <Modal.Body>
        <Form
          entries={entries}
          onSubmit={onHide}
          isShown={show}
          submit={{
            variant: "primary",
            text: "Add"
          }}
          buttons={
            <Button variant="secondary mr-3" onClick={onHide}>
              Cancel
            </Button>
          }
        />
      </Modal.Body>
    </Modal>
  );
}

AddRowModal.propTypes = {
  columns: PropTypes.arrayOf(PropTypes.object),
  onHide: PropTypes.func.isRequired,
  onAdd: PropTypes.func.isRequired,
  title: PropTypes.string,
  show: PropTypes.bool,
  data: PropTypes.arrayOf(PropTypes.object)
};
AddRowModal.defaultProps = {
  columns: [],
  title: null,
  show: false,
  data: []
};
AddRowModal.displayName = "AddRowModal";
