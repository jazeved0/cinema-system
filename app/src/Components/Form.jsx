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
  isEmptyOrNil,
  equal,
  capitalize
} from "Utility";
import hash from "object-hash";
import classNames from "classnames";

import {
  Button,
  Spinner,
  Form as BootstrapForm,
  Row,
  Col,
  InputGroup
} from "react-bootstrap";
import { Prompt } from "react-router-dom";
import { SetInput } from "Components";
import Select from "react-select";

export default function Form(props) {
  const {
    entries,
    isLoading,
    submit: { variant, text },
    onSubmit,
    buttons,
    isShown,
    focusDelay,
    collapse,
    blocking,
    blockingMessage,
    horizontal
  } = props;

  // Key => Entry map
  const entriesMap = useMemo(() => constructMap(entries), [entries]);

  // Controlled input values
  const [values, setValues] = useState(() => calculateInitialState(entries));
  const isEmpty = useMemo(
    () =>
      entries.every(entry => equal(values[entry.key], getDefaultValue(entry))),
    [entries, values]
  );
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
  const trySubmit = useCallback(() => {
    /* eslint-disable no-unused-vars */
    const [_, isValid] = validate(entries, values, true);
    if (isValid) {
      const resolvedValues = {};
      for (const key in values) {
        let val = values[key];
        if (entriesMap[key].type === "combo") {
          val = values[key].value;
        }
        resolvedValues[key] = val;
      }
      onSubmit(resolvedValues);
    } else {
      setShowValidation(true);
    }
  }, [values, onSubmit, entries, entriesMap]);

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
        trySubmit();
      }
    },
    [trySubmit]
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

  // "unique" form hash
  const formHash = useMemo(() => hash(entries), [entries]);

  const inputs = entries.map((entry, i) => (
    <>
      <Form.Input
        type={entry.type || "text"}
        inputKey={entry.key}
        placeholder={placeholderFormats[entry.type || "text"](entry)}
        onChange={onChange}
        onBlur={onBlur}
        onKeyDown={handleKeyPressed}
        value={values[entry.key]}
        isValid={
          validated(entry) &&
          validationStatus[entry.key].result &&
          entry.showValid
        }
        isInvalid={validated(entry) && !validationStatus[entry.key].result}
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
    </>
  ));

  const wrappedInputs = entries.map((entry, i) =>
    isDefined(entry.prefix) ? (
      <InputGroup>
        <InputGroup.Prepend>
          <InputGroup.Text>{entry.prefix}</InputGroup.Text>
        </InputGroup.Prepend>
        {inputs[i]}
      </InputGroup>
    ) : (
      inputs[i]
    )
  );

  const aggregatedEntries = useMemo(
    () => (horizontal ? [] : aggregateEntries(entries)),
    [entries, horizontal]
  );
  const formGroups = horizontal
    ? entries.map((entry, i) => (
        <BootstrapForm.Group
          key={entry.key}
          as={Row}
          controlId={`form-${formHash}-${entry.key}`}
        >
          <BootstrapForm.Label column {...{ [collapse]: 2 }}>
            {entry.name}
          </BootstrapForm.Label>
          <Col {...{ [collapse]: 10 }}>{wrappedInputs[i]}</Col>
        </BootstrapForm.Group>
      ))
    : aggregatedEntries.map((group, i) => (
        <BootstrapForm.Row key={i}>
          {group.map(entry => (
            <BootstrapForm.Group
              as={Col}
              {...{ [collapse]: entry.width }}
              key={entry.key}
              controlId={`form-${formHash}-${entry.key}`}
            >
              <BootstrapForm.Label>{entry.name}</BootstrapForm.Label>
              {wrappedInputs[entry.index]}
            </BootstrapForm.Group>
          ))}
        </BootstrapForm.Row>
      ));

  return (
    <>
      {blocking && !isEmpty && <Prompt message={blockingMessage} />}
      <BootstrapForm noValidate className="_form">
        {/* Input rows */}
        {formGroups}
        {/* Submit row */}
        <BootstrapForm.Group as={Row}>
          <Col sm={{ span: 10, offset: 2 }}>
            <div className="_form--buttons">
              <Button
                className={classNames("_form--submit-button", {
                  "_form--submit-button__loading": isLoading
                })}
                variant={variant}
                onClick={trySubmit}
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
    </>
  );
}
Form.displayName = "Form";
Form.defaultProps = {
  collapse: "sm",
  blockingMessage:
    "Are you sure you want to exit? Your information will not be saved.",
  isShown: true
};

Form.Input = React.forwardRef(({ type, ...props }, ref) => {
  const resolvedType = isDefined(type) ? type : "text";
  const handler = formInputs[resolvedType];
  return handler(props, ref);
});
Form.Input.displayName = "Form.Input";

Form.TextInput = function(props, ref) {
  // Eslint complains because of the way this component was declared
  /* eslint-disable react-hooks/rules-of-hooks */

  const { inputKey, onBlur, message, onChange, type, ...rest } = props;
  return (
    <>
      <BootstrapForm.Control
        onChange={useCallback(e => onChange(inputKey, e), [onChange, inputKey])}
        onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
        ref={ref}
        type={type}
        {...rest}
      />
      <BootstrapForm.Control.Feedback type="invalid" children={message} />
    </>
  );
};

Form.SetInput = function(props, ref) {
  // Eslint complains because of the way this component was declared
  /* eslint-disable react-hooks/rules-of-hooks */

  const { inputKey, onBlur, message, onChange, ...rest } = props;

  return (
    <Form.SmartSetInput
      onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
      onChange={useCallback(e => onChange(inputKey, e), [onChange, inputKey])}
      ref={ref}
      message={message}
      {...rest}
    />
  );
};

Form.ComboInput = function(props, ref) {
  const {
    inputKey,
    onBlur,
    message,
    onChange,
    options,
    isInvalid,
    disabled,
    onKeyDown,
    ...rest
  } = props;
  const derivedOptions = isDefined(options)
    ? options.map(o =>
        typeof o === "string" ? { value: o, label: capitalize(o) } : o
      )
    : null;

  const onKeyPress = e => {
    const code = e.keyCode || e.which;
    // Enter keycode
    if (code === 13) {
      e.stopPropagation();
    } else onKeyDown(e);
  };

  return (
    <>
      <Select
        className={classNames("combo-input", { "is-invalid": isInvalid })}
        classNamePrefix="combo-input"
        onChange={useCallback(e => onChange(inputKey, e), [onChange, inputKey])}
        onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
        onKeyDown={onKeyPress}
        isSearchable
        options={derivedOptions}
        isDisabled={disabled}
        ref={ref}
        {...rest}
      />
      <BootstrapForm.Control.Feedback type="invalid" children={message} />
    </>
  );
};

const formInputs = {
  set: Form.SetInput,
  combo: Form.ComboInput,
  text: (p, r) => Form.TextInput({ ...p, type: "text" }, r),
  password: (p, r) => Form.TextInput({ ...p, type: "password" }, r)
};

const placeholderFormats = {
  combo: entry => `Select ${entry.name.toLowerCase()}`,
  set: entry => `Add ${entry.name.toLowerCase()}`,
  text: entry => `Enter ${entry.name.toLowerCase()}`,
  password: entry => `Enter ${entry.name.toLowerCase()}`
};

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
    className,
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
        className={className}
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

function getDefaultValue(entry) {
  if (entry.type === "set") return [];
  else return "";
}

function calculateInitialState(entries) {
  const state = createObject();
  for (const entry of entries) {
    state[entry.key] = getDefaultValue(entry);
  }
  return state;
}

function calculateInitialFocusState(entries) {
  const state = createObject();
  for (const entry of entries) {
    state[entry.key] = false;
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

const COLUMN_TOTAL = 12;
function aggregateEntries(entries) {
  let groups = [];
  let currentGroup = [];
  let currentWidth = 0;
  for (let i = 0; i < entries.length; ++i) {
    const entry = entries[i];
    const { width } = entry;
    if (isDefined(width)) {
      if (currentWidth + width > COLUMN_TOTAL) {
        // Evict current group and start new one
        groups.push(currentGroup);
        currentWidth = 0;
        currentGroup = [];
      }
      currentGroup.push({ ...entry, index: i });
      currentWidth += entry.width;
    } else {
      if (COLUMN_TOTAL - currentWidth < 2) {
        // Evict current group and start new one
        groups.push(currentGroup);
        currentWidth = 0;
        currentGroup = [];
      }
      currentGroup.push({
        ...entry,
        index: i,
        width: COLUMN_TOTAL - currentWidth
      });
      groups.push(currentGroup);
      currentWidth = 0;
      currentGroup = [];
    }
  }
  // Add trailing groups
  if (currentGroup.length > 0) {
    groups.push(currentGroup);
  }
  return groups;
}
