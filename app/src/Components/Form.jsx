import React, {
  useCallback,
  useEffect,
  useState,
  useMemo,
  useRef
} from "react";
import { createObject, isDefined, isNil, identity } from "Utility";
import classNames from "classnames";

import {
  Button,
  Spinner,
  Form as BootstrapForm,
  Row,
  Col
} from "react-bootstrap";

export default function Form(props) {
  const {
    entries,
    isLoading,
    submit: { variant, text },
    onSubmit,
    buttons,
    isShown
  } = props;

  // Key => Entry map
  const entriesMap = useMemo(() => constructMap(entries), [entries]);

  // Controlled input values
  const [values, setValues] = useState(() => calculateInitialState(entries));
  const onChange = useCallback(
    (key, event) => {
      let processFunc = entriesMap[key].processValue;
      if (isNil(processFunc)) processFunc = identity;
      const newValue = isDefined(event.target) ? event.target.value : "";
      setValues({
        ...values,
        [key]: processFunc(newValue)
      });
    },
    [values, entriesMap]
  );

  // Auto-focus first input field
  const firstInput = useRef(null);
  useEffect(() => {
    if (isShown && isDefined(firstInput.current)) {
      // Select after animation completes
      const timer = setTimeout(() => firstInput.current.focus(), 700);
      return () => clearTimeout(timer);
    }
  }, [isShown]);

  // Input validation calculation & status
  const [showValidation, setShowValidation] = useState(false);
  const [validationStatus, isValid] = useMemo(() => validate(entries, values), [
    entries,
    values
  ]);

  // Button press callbacks
  const tryLogin = useCallback(() => {
    if (isValid) {
      onSubmit(values);
    } else {
      setShowValidation(true);
    }
  }, [values, onSubmit, isValid]);

  useEffect(() => {
    if (!isShown) {
      setValues(calculateInitialState(entries));
      setShowValidation(false);
      setFinishedInputs(calculateInitialFocusState(entries));
    }
  }, [isShown, entries]);

  // Enter press handler
  const handleKeyPressed = useCallback(
    e => {
      var code = e.keyCode || e.which;
      // Enter keycode
      if (code === 13) {
        tryLogin();
      }
    },
    [tryLogin]
  );
  useEffect(() => {
    document.addEventListener("keydown", handleKeyPressed, false);
    return () =>
      document.removeEventListener("keydown", handleKeyPressed, false);
  }, [handleKeyPressed]);

  // Validate upon lost focus
  const [finishedInputs, setFinishedInputs] = useState(
    calculateInitialFocusState(entries)
  );
  const onBlur = useCallback(
    key => {
      if (values[key] !== "")
        setFinishedInputs({ ...finishedInputs, [key]: true });
    },
    [values, finishedInputs]
  );

  // Whether a column should appear with a validation outline
  const validated = useCallback(
    entry => showValidation || finishedInputs[entry.key],
    [showValidation, finishedInputs]
  );

  return (
    <BootstrapForm noValidate className="_form">
      {/* Input rows */}
      {entries.map((entry, i) => (
        <BootstrapForm.Group
          key={entry.key}
          as={Row}
          controlId={`loginPane-${entry.key}`}
        >
          <BootstrapForm.Label column sm={2}>
            {entry.name}
          </BootstrapForm.Label>
          <Col sm={10}>
            <Form.Input
              type={entry.type || "text"}
              inputKey={entry.key}
              placeholder={`Enter ${entry.name.toLowerCase()}`}
              onChange={onChange}
              onBlur={onBlur}
              value={values[entry.key]}
              isValid={
                validated(entry) &&
                validationStatus[entry.key].result &&
                entry.showValid
              }
              isInvalid={
                validated(entry) && !validationStatus[entry.key].result
              }
              ref={i === 0 ? firstInput : undefined}
              disabled={isLoading}
            />
            <BootstrapForm.Control.Feedback type="invalid">
              {validationStatus[entry.key].message}
            </BootstrapForm.Control.Feedback>
            {isDefined(entry.info) ? (
              <BootstrapForm.Text className="text-muted">
                {entry.info}
              </BootstrapForm.Text>
            ) : null}
          </Col>
        </BootstrapForm.Group>
      ))}
      {/* Submit row */}
      <BootstrapForm.Group as={Row}>
        <Col sm={{ span: 10, offset: 2 }}>
          <div className="_form--buttons">
            <Button
              className={classNames("_form--submit-button", {
                "_form--submit-button__loading": isLoading
              })}
              variant={variant}
              onClick={tryLogin}
              disabled={isLoading}
            >
              {text}
              <div className="_form--submit-button-spinner">
                <Spinner animation="border" size="sm" variant="light" />
              </div>
            </Button>
            {buttons}
          </div>
        </Col>
      </BootstrapForm.Group>
    </BootstrapForm>
  );
}
Form.displayName = "Form";

Form.Input = React.forwardRef(
  ({ onChange, onBlur, inputKey, ...rest }, ref) => (
    <BootstrapForm.Control
      onChange={useCallback(e => onChange(inputKey, e), [onChange, inputKey])}
      onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
      ref={ref}
      {...rest}
    />
  )
);
Form.Input.displayName = "Form.Input";

// ? =================
// ? Utility functions
// ? =================

function calculateInitialState(entries) {
  const state = createObject();
  for (let i = 0; i < entries.length; ++i) {
    state[entries[i].key] = "";
  }
  return state;
}

function calculateInitialFocusState(entries) {
  const state = createObject();
  for (let i = 0; i < entries.length; ++i) {
    state[entries[i].key] = false;
  }
  return state;
}

function constructMap(array) {
  return Object.assign(
    {},
    ...array.map(({ key, ...rest }) => ({ [key]: rest }))
  );
}

function validate(entries, values) {
  let allPass = true;
  let validationStatus = {};

  // Validate each entry separately
  for (const entry of entries) {
    const value = values[entry.key];
    const [result, passes] = applySteps(steps, value, entry);
    allPass = allPass && passes;
    validationStatus[entry.key] = result;
  }

  return [validationStatus, allPass];
}

const steps = [
  // Required field validator
  {
    canApply: entry => !!entry.required,
    apply: (value, entry) => {
      if (value.trim().length === 0) {
        return {
          result: false,
          message: `${entry.name} is a required field`
        };
      } else return null;
    }
  },
  // Custom validator function
  {
    canApply: entry => isDefined(entry.validator),
    apply: (value, entry) => entry.validator(value)
  }
];

function applySteps(steps, value, entry) {
  for (const step of steps) {
    if (step.canApply(entry)) {
      const result = step.apply(value, entry);
      if (isDefined(result)) {
        let resultObject = result;
        if (typeof result === "boolean") {
          resultObject = {
            result,
            message: ""
          };
        }

        if (!resultObject.result) {
          return [resultObject, false];
        }
      }
    }
  }

  // Default: passes
  return [
    {
      result: true,
      message: ""
    },
    true
  ];
}
