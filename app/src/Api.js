import { useState, useEffect } from "react";
import { buildPath, log, useFallingEdge } from "Utility";
import axios from "axios";

export const API_ROOT =
  process.env.NODE_ENV === "development"
    ? "http://localhost:5000/"
    : "https://api.cinema-system.ga/";

export function api(path) {
  return buildPath(API_ROOT, path);
}

export function useCompanies() {
  const [companies, setCompanies] = useState([]);
  useEffect(() => {
    axios
      .get(api("/companies"))
      .then(response => {
        setCompanies(response.data);
      })
      .catch(error => {
        log(
          `Error ${error.status} ocurred while fetching company list: ${error.message}`
        );
        return new Promise(resolve => setTimeout(resolve, 1000));
      });
  }, []);

  return companies;
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
