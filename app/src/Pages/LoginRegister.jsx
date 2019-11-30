import React, { useState, useCallback, useEffect, useContext } from "react";
import classNames from "classnames";
import { isDefined } from "Utility";
import { useRouteMatch, useHistory, Route } from "react-router-dom";
import { useAuth, decodeJWT } from "Authentication";
import { useApiForm } from "Api";

import {
  CtaButton,
  Form,
  Link,
  Page,
  Card,
  NotificationList,
  Redirect
} from "Components";
import {
  RegisterMenu,
  RegisterCustomer,
  RegisterUser,
  RegisterManager,
  RegisterManagerCustomer
} from "Pages";
import AnimateHeight from "react-animate-height";
import { CSSTransition } from "react-transition-group";
import { Modal } from "react-bootstrap";

// Context for passing error state information down the tree
const LoginErrorContext = React.createContext({
  errors: [],
  onDismiss: () => null
});

export default function LoginRegister() {
  const [activeLogin, setActiveLogin] = useState(false);
  const registerOpen = isDefined(useRouteMatch({ path: "/register" }));
  const history = useHistory();

  // Form submission
  const { isAuthenticated, firstName, loadAuth } = useAuth();
  const { errorContext, isLoading, onSubmit } = useApiForm({
    show: activeLogin && !registerOpen,
    path: "/login",
    onSuccess: ({ response }) => {
      const { token } = response;
      const session = decodeJWT(token);
      loadAuth({ ...session, token });
    }
  });

  return (
    <Page title={activeLogin ? "Login" : "Home"}>
      <h1 className="intro-space">Cinema System</h1>
      <p className="lead">
        This website is the result of a semester-long group project for CS 4400:
        Intro Database Systems with Professor Mark Moss. In this project, we
        have developed a movie system using relational database concepts and
        developed an application layer/frontend with Python Flask and React.
      </p>
      <div className="login-register">
        {isAuthenticated ? (
          <Card className="login-register__welcome">
            <h4>Welcome back, {firstName}</h4>
            <CtaButton
              variant="primary"
              icon="chevronDoubleRight"
              animated
              glowing
              onClick={() => history.push("/app")}
            >
              Go to App
            </CtaButton>
          </Card>
        ) : (
          <LoginErrorContext.Provider value={errorContext}>
            <LoginRegister.LoginButton
              activeLogin={activeLogin}
              isLoading={isLoading}
              onSubmit={onSubmit}
              onOpen={() => setActiveLogin(true)}
              onClose={() => setActiveLogin(false)}
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
          </LoginErrorContext.Provider>
        )}
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
  const { errors, onDismiss } = useContext(LoginErrorContext);
  return (
    <div className="login-pane">
      <button type="button" className="login-pane--close" onClick={onClose}>
        <span aria-hidden="true">×</span>
        <span className="sr-only">Close</span>
      </button>
      <NotificationList
        type="toast"
        items={errors}
        onDismiss={onDismiss}
        transitionLength={750}
      />
      <Form
        onSubmit={onSubmit}
        isLoading={isLoading}
        isShown={isShown}
        focusDelay={700}
        horizontal
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

const registerPanes = {
  user: RegisterUser,
  customer: RegisterCustomer,
  manager: RegisterManager,
  "manager-customer": RegisterManagerCustomer
};
LoginRegister.RegisterModal = function(props) {
  const { show, onHide } = props;
  const base = "/register";
  const panes = Object.keys(registerPanes);
  const { isAuthenticated } = useAuth();
  return (
    <>
      {Redirect({
        when: isAuthenticated,
        from: [base, ...panes.map(k => `${base}/${k}`)],
        to: "/"
      })}
      <Modal
        show={show}
        onHide={onHide}
        dialogClassName="register-modal modal-container"
      >
        <Modal.Header closeButton />
        <div className="content">
          {panes.map(k => {
            const PaneComponent = registerPanes[k];
            return (
              <Route path={`${base}/${k}`} exact key={k}>
                {({ match }) => (
                  <CSSTransition
                    in={match != null}
                    timeout={300}
                    classNames="register-pane"
                    unmountOnExit
                  >
                    <div className="register-pane">
                      <PaneComponent />
                    </div>
                  </CSSTransition>
                )}
              </Route>
            );
          })}
          <Route path={base} exact>
            {({ match }) => (
              <CSSTransition
                in={match != null}
                timeout={300}
                classNames="register-pane"
                unmountOnExit
              >
                <div className="register-pane">
                  <RegisterMenu />
                </div>
              </CSSTransition>
            )}
          </Route>
        </div>
      </Modal>
    </>
  );
};
LoginRegister.RegisterModal.displayName = "LoginRegister.RegisterModal";
