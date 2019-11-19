import React, { useState, useCallback, useEffect } from "react";
import classNames from "classnames";
import { isDefined } from "Utility";
import { useRouteMatch, useHistory, Switch, Route } from "react-router-dom";

import { CtaButton, Form, Link, Page } from "Components";
import {
  RegisterMenu,
  RegisterCustomer,
  RegisterUser,
  RegisterManager,
  RegisterManagerCustomer
} from "Pages";
import AnimateHeight from "react-animate-height";
import { Modal } from "react-bootstrap";

import "./style.scss";

export default function LoginRegister() {
  // TODO implement API functionality
  // TODO implement session store as context
  // TODO implement correct navigation upon successful login
  // TODO implement shaking button upon incorrect login & error message

  const [isLoading, setIsLoading] = useState(false);
  const [activeLogin, setActiveLogin] = useState(false);
  const registerOpen = isDefined(useRouteMatch({ path: "/register" }));
  const history = useHistory();
  const title = activeLogin ? "Login" : "Home";

  useEffect(() => {
    if (isLoading && registerOpen) {
      setIsLoading(false);
    }
  }, [isLoading, registerOpen]);

  return (
    <Page title={title}>
      <h1 className="intro-space">Cinema System</h1>
      <p className="lead">
        This website is the result of a semester-long group project for CS 4400:
        Intro Database Systems with Professor Mark Moss. In this project, we
        have developed a movie system using relational database concepts and
        developed an application layer/frontend with Python Flask and React.
      </p>
      <div className="login-register">
        <LoginRegister.LoginButton
          activeLogin={activeLogin}
          isLoading={isLoading}
          onSubmit={() => setIsLoading(true)}
          onOpen={() => setActiveLogin(true)}
          onClose={() => {
            if (isLoading) setIsLoading(false);
            setActiveLogin(false);
          }}
        />
        <CtaButton
          variant="primary"
          icon="asterisk"
          className={classNames("register", { active: activeLogin })}
          animated
          glowing
          onClick={() => history.push("/register")}
        >
          Register
        </CtaButton>
      </div>
      <LoginRegister.RegisterModal
        show={registerOpen}
        onHide={() => history.push("/")}
      />
    </Page>
  );
}
LoginRegister.displayName = "LoginRegister";

// ? ==============
// ? Sub-components
// ? ==============

LoginRegister.LoginButton = function(props) {
  // Eslint complains because of the way this component was declared
  /* eslint-disable react-hooks/rules-of-hooks */

  const { onOpen, onClose, activeLogin, isLoading, onSubmit } = props;
  const [isOpen, setIsOpen] = useState(false);
  const [isTransitioning, setIsTransitioning] = useState(false);
  const [isReverseTransitioning, setIsReverseTransitioning] = useState(false);

  const onPressLogin = useCallback(() => {
    if (!activeLogin) onOpen();
  }, [activeLogin, onOpen]);

  const onPressClose = useCallback(() => {
    if (activeLogin) onClose();
  }, [activeLogin, onClose]);

  useEffect(() => {
    if (activeLogin) {
      // Rising edge
      setIsOpen(true);
      setIsTransitioning(true);
      const timer = setTimeout(() => {
        setIsTransitioning(false);
      }, 500);
      return () => {
        clearTimeout(timer);
      };
    } else {
      // Falling edge
      setIsOpen(false);
      setIsReverseTransitioning(true);
      const timer = setTimeout(() => {
        setIsReverseTransitioning(false);
      }, 700);
      return () => {
        clearTimeout(timer);
      };
    }
  }, [activeLogin, isOpen]);

  return (
    <CtaButton
      variant="secondary"
      icon="signIn"
      as="div"
      animated={!isOpen}
      glowing
      onClick={onPressLogin}
      content={
        <div className="login-wrapper">
          <AnimateHeight
            duration={isReverseTransitioning ? 300 : 500}
            height={isOpen && !isTransitioning ? "auto" : 0}
          >
            <LoginRegister.Pane
              isShown={isOpen}
              onClose={onPressClose}
              onSubmit={onSubmit}
              isLoading={isLoading}
            />
          </AnimateHeight>
        </div>
      }
      className={classNames("login-button", {
        "login-button__active": isOpen,
        "login-button__transitioning": isTransitioning,
        "login-button__reverse": isReverseTransitioning
      })}
    >
      Login
    </CtaButton>
  );
};
LoginRegister.LoginButton.displayName = "LoginRegister.LoginButton";

LoginRegister.Pane = function(props) {
  const { isShown, onClose, isLoading, onSubmit } = props;
  return (
    <div className="login-pane">
      <button type="button" className="login-pane--close" onClick={onClose}>
        <span aria-hidden="true">×</span>
        <span className="sr-only">Close</span>
      </button>
      <Form
        onSubmit={onSubmit}
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
LoginRegister.Pane.displayName = "LoginRegister.Pane";

LoginRegister.RegisterModal = function(props) {
  const { show, onHide } = props;
  const base = "/register";
  return (
    <Modal show={show} onHide={onHide} dialogClassName="register-modal">
      <Modal.Header closeButton />
      <div className="content">
        <Switch>
          <Route path={`${base}/user`}>
            <RegisterUser />
          </Route>
          <Route path={`${base}/customer`}>
            <RegisterCustomer />
          </Route>
          <Route path={`${base}/manager`}>
            <RegisterManager /></Route>
          <Route path={`${base}/manager-customer`}>
            <RegisterManagerCustomer /></Route>
          <Route path="*">
            <RegisterMenu />
          </Route>
        </Switch>
      </div>
    </Modal>
  );
};
LoginRegister.RegisterModal.displayName = "LoginRegister.RegisterModal";
