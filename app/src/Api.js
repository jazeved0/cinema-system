import { useState, useEffect } from "react";
import {
  buildPath,
  log,
  useFallingEdge,
  retry as retryPromise,
  isDefined
} from "Utility";
import { useAuth } from "Authentication";
import axios from "axios";

export const API_ROOT =
  process.env.NODE_ENV === "development"
    ? "http://localhost:5000/"
    : "https://api.cinema-system.ga/";

export function api(path) {
  return buildPath(API_ROOT, path);
}

export function useCompanies() {
  // eslint-disable-next-line no-unused-vars
  const [companies, isLoading] = useGet("/companies", {
    config: { params: { only_names: true } }
  });
  return isLoading ? [] : companies;
}

function handleAxiosError(error) {
  if (error.response) {
    log(`${error.response.status} Error: ${error.response.data}`);
    return error.response.data;
  } else if (error.request) {
    log(`Client Error: ${JSON.stringify(error.request)}`);
    return `Could not make request. Check network connectivity`;
  } else {
    log(`Generic Error: ${error.message}`);
    return error.message;
  }
}

export function useAuthGet(route, options = {}) {
  const { token } = useAuth();
  return useGet(route, {
    ...options,
    config: withAuthHeader(options, token)
  });
}

export function withAuthHeader({ config = {} }, token) {
  return {
    ...config,
    headers: {
      ...(isDefined(config.headers) ? config.headers : { Authorization: token })
    }
  };
}

export function useGet(route, { retry = true, config = {} }) {
  /* eslint-disable react-hooks/exhaustive-deps */
  const [result, setResult] = useState(null);
  const [isLoading, setIsLoading] = useState(false);
  useRequest(route, "get", {
    retry,
    config,
    onStart: () => {
      setIsLoading(true);
    },
    onFailure: () => {
      setIsLoading(false);
    },
    onSuccess: data => {
      setIsLoading(false);
      setResult(data);
    }
  });

  return [result, isLoading, setResult];
}

export function useAuthRequest(
  route,
  method,
  { retry = true, config = {}, onStart, onFailure, onSuccess }
) {
  const { token } = useAuth();
  useEffect(() => {
    onStart();
    performAuthRequest(route, method, token, {
      retry,
      config,
      onFailure,
      onSuccess
    });
  }, [route]);
}

export function useRequest(
  route,
  method,
  { retry = true, config = {}, onStart, onFailure, onSuccess }
) {
  useEffect(() => {
    onStart();
    performRequest(route, method, {
      retry,
      config,
      onFailure,
      onSuccess
    });
  }, [route]);
}

export function performAuthRequest(
  route,
  method,
  token,
  { retry = true, config = {}, onFailure, onSuccess }
) {
  const derivedConfig = withAuthHeader({ config }, token);
  const request = () => axios({ method, url: api(route), ...derivedConfig });
  (retry ? retryPromise(request, 1000, `fetching ${route}`) : request())
    .then(response => onSuccess(response.data))
    .catch(error => onFailure(handleAxiosError(error)));
}

export function performRequest(
  route,
  method,
  { retry = true, config = {}, onFailure, onSuccess }
) {
  const request = () => axios({ method, url: api(route), ...config });
  (retry ? retryPromise(request, 1000, `fetching ${route}`) : request())
    .then(response => onSuccess(response.data))
    .catch(error => onFailure(handleAxiosError(error)));
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
    setIsLoading(false);
    clearErrors();
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
      .catch(error => setError(handleAxiosError(error)));
  };

  return { errorContext, isLoading, onSubmit };
}
