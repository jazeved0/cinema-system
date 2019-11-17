import React, {
  useCallback,
  useEffect,
  useState,
  useMemo,
  useRef
} from "react";
import {
  createObject,
  isDefined,
  isNil,
  identity,
  isEmptyOrNil
} from "Utility";
import classNames from "classnames";

import {
  Button,
  Spinner,
  Form as BootstrapForm,
  Row,
  Col
} from "react-bootstrap";
import { SetInput } from "Components";

export default function Form(props) {
  const {
    entries,
    isLoading,
    submit: { variant, text },
    onSubmit,
    buttons,
    isShown,
    focusDelay,
    collapse
  } = props;

  // Key => Entry map
  const entriesMap = useMemo(() => constructMap(entries), [entries]);

  // Controlled input values
  const [values, setValues] = useState(() => calculateInitialState(entries));
  const onChange = useCallback(
    (key, event) => {
      let processFunc = entriesMap[key].processValue;
      if (isNil(processFunc)) processFunc = identity;
      const newValue = isDefined(event.target) ? event.target.value : event;
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
      const timer = setTimeout(() => firstInput.current.focus(), focusDelay);
      return () => clearTimeout(timer);
    }
  }, [isShown, focusDelay]);

  // Input validation calculation & status
  const [showValidation, setShowValidation] = useState(false);
  // eslint-disable-next-line no-unused-vars
  const [validationStatus, _] = useMemo(
    () => validate(entries, values, showValidation),
    [entries, values, showValidation]
  );

  // Button press callbacks
  const tryLogin = useCallback(() => {
    /* eslint-disable no-unused-vars */
    const [_, isValid] = validate(entries, values, true);
    if (isValid) {
      onSubmit(values);
    } else {
      setShowValidation(true);
    }
  }, [values, onSubmit, entries]);

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
          <BootstrapForm.Label column {...{ [collapse]: 2 }}>
            {entry.name}
          </BootstrapForm.Label>
          <Col {...{ [collapse]: 10 }}>
            <Form.Input
              type={entry.type || "text"}
              inputKey={entry.key}
              placeholder={`Enter ${entry.name.toLowerCase()}`}
              onChange={onChange}
              onBlur={onBlur}
              onKeyDown={handleKeyPressed}
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
              {...entry.props}
              message={validationStatus[entry.key].message}
            />
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
Form.defaultProps = {
  collapse: "sm"
};

Form.Input = React.forwardRef(
  ({ onChange, onBlur, inputKey, type, message, ...rest }, ref) => {
    if (type === "text" || type === "password") {
      return (
        <>
          <BootstrapForm.Control
            onChange={useCallback(e => onChange(inputKey, e), [
              onChange,
              inputKey
            ])}
            onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
            ref={ref}
            type={type}
            {...rest}
          />
          <BootstrapForm.Control.Feedback type="invalid" children={message} />
        </>
      );
    } else if (type === "set") {
      return (
        <Form.SmartSetInput
          onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
          onChange={useCallback(e => onChange(inputKey, e), [
            onChange,
            inputKey
          ])}
          ref={ref}
          message={message}
          {...rest}
        />
      );
    } else return null;
  }
);
Form.Input.displayName = "Form.Input";

Form.SmartSetInput = React.forwardRef((props, ref) => {
  const {
    value,
    onChange,
    onBlur,
    processValue,
    setValidator,
    max,
    isInvalid,
    message,
    disabled,
    onKeyDown,
    renderItem,
    ...rest
  } = props;
  const [currentText, setCurrentText] = useState("");
  const onRemove = index => onChange(value.filter((_o, i) => i !== index));
  const onAdd = () => {
    if (currentText.trim() === "") return;
    if (passes) {
      onChange([...value, currentText]);
      setCurrentText("");
      setShowValidation(false);
    } else {
      setShowValidation(true);
    }
  };
  const onKeyPress = e => {
    const code = e.keyCode || e.which;
    // Enter keycode
    if (code === 13) {
      if (currentText.trim().length > 0) {
        onAdd();
        e.stopPropagation();
      } else onKeyDown(e);
    }
  };

  const setValue = newValue => {
    const processed = processValue(newValue, currentText);
    if (processed.length === 0) {
      setShowValidation(false);
    }
    setCurrentText(processed);
  };

  const [result, passes] = applySteps({
    steps: [
      { canApply: () => true, apply: value => setValidator(value) },
      {
        canApply: () => isDefined(max),
        apply: () => {
          if (value.length >= max)
            return {
              result: false,
              message: `Maximum ${max} already reached`
            };
        }
      }
    ],
    value: currentText
  });
  const [showValidation, setShowValidation] = useState(false);
  const derivedIsInvalid = isInvalid || (!passes && showValidation);
  const derivedMessage = derivedIsInvalid
    ? isEmptyOrNil(result.message)
      ? message
      : result.message
    : null;
  const onLostFocus = () => {
    setShowValidation(false);
    onBlur();
  };

  return (
    <div className={classNames({ "is-invalid": derivedIsInvalid })}>
      <SetInput
        items={value}
        addItem={onAdd}
        removeItem={onRemove}
        disabled={disabled}
        addDisabled={currentText.trim() === "" || !passes}
        renderItem={renderItem}
      >
        <BootstrapForm.Control
          {...rest}
          type="text"
          ref={ref}
          value={currentText}
          disabled={disabled}
          isInvalid={derivedIsInvalid}
          onBlur={onLostFocus}
          onKeyDown={onKeyPress}
          onChange={e => setValue(e.target.value)}
        />
      </SetInput>
      <BootstrapForm.Control.Feedback
        type="invalid"
        children={derivedMessage}
      />
    </div>
  );
});
Form.SmartSetInput.displayName = "Form.SmartSetInput";
Form.SmartSetInput.defaultProps = {
  setValidator: () => true,
  processValue: a => a
};

// ? =================
// ? Utility functions
// ? =================

function calculateInitialState(entries) {
  const state = createObject();
  for (let i = 0; i < entries.length; ++i) {
    if (entries[i].type === "set") {
      state[entries[i].key] = [];
    } else {
      state[entries[i].key] = "";
    }
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

function validate(entries, values, hasSubmitted) {
  let allPass = true;
  let validationStatus = {};

  // Validate each entry separately
  for (const entry of entries) {
    const value = values[entry.key];
    const [result, passes] = applySteps({
      steps,
      value,
      entry,
      values,
      hasSubmitted
    });
    allPass = allPass && passes;
    validationStatus[entry.key] = result;
  }

  return [validationStatus, allPass];
}

const steps = [
  // Required field validator
  {
    canApply: entry => !!entry.required,
    apply: ({ value, entry }) => {
      if (typeof value === "string") {
        if (value.trim().length === 0) {
          return {
            result: false,
            message: `${entry.name} is a required field`
          };
        } else return null;
      } else if (typeof value === "object" && Array.isArray(value)) {
        if (value.length === 0) {
          return {
            result: false,
            message: `${entry.name} is a required field`
          };
        } else return null;
      } else return null;
    }
  },
  // Custom validator function
  {
    canApply: entry => isDefined(entry.validator),
    apply: ({ entry, ...rest }) => entry.validator(rest)
  }
];

function applySteps({ steps, value, entry, values, hasSubmitted }) {
  for (const step of steps) {
    if (step.canApply(entry)) {
      const result = step.apply({ value, entry, values, hasSubmitted });
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
