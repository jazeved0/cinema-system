import React, { useState, useCallback, useEffect } from "react";
import classNames from "classnames";

import { CtaButton, Form, Link } from "Components";
import AnimateHeight from "react-animate-height";
import { Page } from "Components";

import "./style.scss";

export default function Login() {
  const [activeLogin, setActiveLogin] = useState(false);
  const [isTransitioning, setIsTransitioning] = useState(false);
  const [isReverseTransitioning, setIsReverseTransitioning] = useState(false);

  // TODO implement API functionality
  // TODO implement session store as context
  // TODO implement correct navigation upon successful login
  // TODO implement shaking button upon incorrect login & error message
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
    <Page title={activeLogin ? "Login" : "Home"}>
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
              <Login.Pane isShown={activeLogin} onClose={onPressClose} />
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
    </Page>
  );
}
Login.displayName = "Login";

// ? ==============
// ? Sub-components
// ? ==============

Login.Pane = function(props) {
  // CRA throws error due to "nested" component declaration
  /* eslint-disable react-hooks/rules-of-hooks */

  const { isShown, onClose } = props;
  const [isLoading, setIsLoading] = useState(false);

  const close = () => {
    if (isLoading) {
      setIsLoading(false);
    }
    onClose();
  };

  return (
    <div className="login-pane">
      <button type="button" className="login-pane--close" onClick={close}>
        <span aria-hidden="true">×</span>
        <span className="sr-only">Close</span>
      </button>
      <Form
        onSubmit={() => setIsLoading(true)}
        isLoading={isLoading}
        isShown={isShown}
        focusDelay={700}
        entries={[
          { key: "username", required: true, name: "Username" },
          {
            key: "password",
            required: true,
            name: "Password",
            type: "password"
          }
        ]}
        buttons={
          <Link className="btn btn-secondary" href="/register">
            Register
          </Link>
        }
        submit={{
          variant: "primary",
          text: "Login"
        }}
      ></Form>
    </div>
  );
};
Login.Pane.displayName = "Login.Pane";
