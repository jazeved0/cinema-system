import { useEffect, useState } from "react";
import axios from "axios";
import { log, api } from "./string";

// Runs an effect hook once, simulating componentDidMount/componentWillUnmount
export function useEffectOnce(effectFunc) {
  useEffect(effectFunc, []);
}

// Runs effect upon rising edge of boolean condition
export function useRisingEdge(condition, effect) {
  useEffect(() => {
    if (!condition) return effect;
  }, [condition, effect]);
}

// Runs effect upon falling edge of boolean condition
export function useFallingEdge(condition, effect) {
  useEffect(() => {
    if (!!condition) return effect;
  }, [condition, effect]);
}

// Exposes loading, errors, and submission callback to API-enabled forms
export function useApiForm({ path, show = true, onSuccess }) {
  // Errors
  const [errors, setErrors] = useState([]);
  const onDismiss = id => setErrors(errors.filter(e => e.id !== id));
  const errorContext = { errors, onDismiss };
  const clearErrors = () => setErrors([]);
  const setError = content =>
    setErrors([{ id: 0, variant: "danger", message: content }]);

  // Loading state
  const [isLoading, setIsLoading] = useState(false);

  // Reset loading state/errors when hidden
  useFallingEdge(show, () => {
    if (isLoading) setIsLoading(false);
    if (errors.length > 0) clearErrors();
  });

  // On submission logic
  const onSubmit = params => {
    setIsLoading(true);
    axios
      .post(api(path), params)
      .then(response => {
        setIsLoading(false);
        clearErrors();
        onSuccess(response.data);
      })
      .catch(error => {
        setIsLoading(false);
        if (error.response) {
          log(`${error.response.status} Error: ${error.response.data}`);
          setError(error.response.data);
        }
      });
  };

  return { errorContext, isLoading, onSubmit };
}
