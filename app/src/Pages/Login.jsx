import React, {
  useState,
  useCallback,
  useEffect,
  useMemo,
  useRef
} from "react";
import classNames from "classnames";
import { createObject, isDefined, isNil, identity } from "Utility";

import { CtaButton } from "Components";
import AnimateHeight from "react-animate-height";
import { Form, Row, Col, Button, Spinner } from "react-bootstrap";

import "./style.scss";

document.addEventListener(
  "focusin",
  function() {
    console.log("focused: ", document.activeElement);
  },
  true
);

export default function Login() {
  const [activeLogin, setActiveLogin] = useState(false);
  const [isTransitioning, setIsTransitioning] = useState(false);
  const [isReverseTransitioning, setIsReverseTransitioning] = useState(false);

  const onPressLogin = useCallback(() => {
    if (!activeLogin) {
      setActiveLogin(true);
      setIsTransitioning(true);
    }
  }, [activeLogin]);

  useEffect(() => {
    if (isTransitioning) {
      const timer = setTimeout(() => {
        setIsTransitioning(false);
      }, 500);
      return () => {
        clearTimeout(timer);
      };
    } else if (isReverseTransitioning) {
      const timer = setTimeout(() => {
        setIsReverseTransitioning(false);
      }, 1200);
      return () => {
        clearTimeout(timer);
      };
    }
  }, [isTransitioning, isReverseTransitioning]);

  const onPressClose = useCallback(() => {
    if (activeLogin) {
      setActiveLogin(false);
      setIsReverseTransitioning(true);
    }
  }, [activeLogin]);

  return (
    <>
      <h1 className="intro-space">Cinema System</h1>
      <p className="lead">
        This website is the result of a semester-long group project for CS 4400:
        Intro Database Systems with Professor Mark Moss. In this project, we
        have developed a movie system using relational database concepts and
        developed an application layer/frontend with Python Flask and React.
      </p>
      <CtaButton
        variant="secondary"
        icon="signIn"
        as="div"
        animated={!activeLogin}
        glowing
        onClick={onPressLogin}
        content={
          <div className="login-wrapper">
            <AnimateHeight
              duration={isReverseTransitioning ? 300 : 500}
              height={activeLogin && !isTransitioning ? "auto" : 0}
            >
              <Login.PaneController
                isShown={activeLogin}
                onClose={onPressClose}
              />
            </AnimateHeight>
          </div>
        }
        className={classNames("login-button", {
          "login-button__active": activeLogin,
          "login-button__transitioning": isTransitioning,
          "login-button__reverse": isReverseTransitioning
        })}
      >
        Login
      </CtaButton>
    </>
  );
}
Login.displayName = "Login";

// ? ==============
// ? Sub-components
// ? ==============

Login.PaneController = function(props) {
  // CRA throws error due to "nested" component declaration
  /* eslint-disable react-hooks/rules-of-hooks */

  const { isShown, onClose } = props;

  const close = () => {
    if (isLoading) {
      setIsLoading(false);
    }
    onClose();
  };

  const [isLoading, setIsLoading] = useState(false);
  return (
    <Login.Pane
      onRegister={() => null}
      onLogin={() => setIsLoading(true)}
      isLoading={isLoading}
      isShown={isShown}
      onClose={close}
    />
  );
};

const formEntries = [
  { key: "username", required: true, name: "Username" },
  { key: "password", required: true, name: "Password", type: "password" }
];
Login.Pane = function(props) {
  // CRA throws error due to "nested" component declaration
  /* eslint-disable react-hooks/rules-of-hooks */

  const { onRegister, onLogin, onClose, isLoading, isShown } = props;

  // Construct mapping
  const formEntriesMap = useMemo(
    () =>
      Object.assign(
        {},
        ...formEntries.map(({ key, ...rest }) => ({ [key]: rest }))
      ),
    []
  );

  // Controlled input values
  const [values, setValues] = useState(() =>
    calculateInitialState(formEntries)
  );
  const onChange = useCallback(
    (key, event) => {
      let processFunc = formEntriesMap[key].processValue;
      if (isNil(processFunc)) processFunc = identity;
      const newValue = isDefined(event.target) ? event.target.value : "";
      setValues({
        ...values,
        [key]: processFunc(newValue)
      });
    },
    [values, formEntriesMap]
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
  const [validationStatus, isValid] = useMemo(() => {
    let validationStatus = {};
    let allPass = true;
    for (const i in formEntries) {
      const { key, required, name, validator } = formEntries[i];
      const value = values[key];
      if (required) {
        // Validate based on empty or not
        if (value.trim().length === 0) {
          validationStatus[key] = {
            result: false,
            message: `${name} is a required field`
          };
          allPass = false;
          continue;
        }
      }

      // Custom validator
      if (isDefined(validator)) {
        const result = validator(value);
        if (typeof result === "boolean") {
          allPass = allPass && result;
          validationStatus[key] = {
            result,
            message: ""
          };
        } else {
          allPass = allPass && result.result;
          validationStatus[key] = result;
        }
        continue;
      }

      // Default case
      validationStatus[key] = {
        result: true,
        message: ""
      };
    }
    return [validationStatus, allPass];
  }, [values]);

  // Button press callbacks
  const tryLogin = useCallback(() => {
    if (isValid) {
      onLogin(values.username, values.password);
    } else {
      setShowValidation(true);
    }
  }, [values, onLogin, isValid]);

  const close = useCallback(() => {
    setValues(calculateInitialState(formEntries));
    setShowValidation(false);
    setFinishedInputs(calculateInitialFocusState(formEntries));
    onClose();
  }, [onClose]);

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
    calculateInitialFocusState(formEntries)
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
    <div className="login-pane">
      <button type="button" className="login-pane--close" onClick={close}>
        <span aria-hidden="true">×</span>
        <span className="sr-only">Close</span>
      </button>
      <Form noValidate>
        {/* Input rows */}
        {formEntries.map((entry, i) => (
          <Form.Group
            as={Row}
            controlId={`loginPane-${entry.key}`}
            key={entry.key}
          >
            <Form.Label column sm={2}>
              {entry.name}
            </Form.Label>
            <Col sm={10}>
              <Login.FormInput
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
              <Form.Control.Feedback type="invalid">
                {validationStatus[entry.key].message}
              </Form.Control.Feedback>
              {isDefined(entry.info) ? (
                <Form.Text className="text-muted">{entry.info}</Form.Text>
              ) : null}
            </Col>
          </Form.Group>
        ))}
        {/* Submit row */}
        <Form.Group as={Row}>
          <Col sm={{ span: 10, offset: 2 }}>
            <div className="login-pane--buttons">
              <Button
                className={classNames("login-pane--login-button", {
                  "login-pane--login-button__loading": isLoading
                })}
                onClick={tryLogin}
                disabled={isLoading}
              >
                Login
                <div className="login-pane--login-button-spinner">
                  <Spinner animation="border" size="sm" variant="light" />
                </div>
              </Button>
              <Button variant="secondary" onClick={onRegister}>
                Register
              </Button>
            </div>
          </Col>
        </Form.Group>
      </Form>
    </div>
  );
};
Login.Pane.displayName = "Login.Pane";

Login.FormInput = React.forwardRef(
  ({ onChange, onBlur, inputKey, ...rest }, ref) => (
    <Form.Control
      onChange={useCallback(e => onChange(inputKey, e), [onChange, inputKey])}
      onBlur={useCallback(() => onBlur(inputKey), [onBlur, inputKey])}
      ref={ref}
      {...rest}
    />
  )
);
Login.FormInput.displayName = "Login.FormInput";

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
