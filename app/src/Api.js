import { useState, useEffect, useCallback } from "react";
import {
  buildPath,
  log,
  useFallingEdge,
  retry as retryPromise,
  isDefined
} from "Utility";
import { useAuth } from "Authentication";
import axios from "axios";

// APO host (depending on development or production)
export const API_ROOT =
  process.env.NODE_ENV === "development"
    ? "http://localhost:5000/"
    : "https://api.cinema-system.ga/";

// Resolves API route via API_ROOT
export function api(path) {
  return buildPath(API_ROOT, path);
}

// Shortcut hook to use list of company names via the API
export function useCompanies() {
  // eslint-disable-next-line no-unused-vars
  const [{ companies }, { isLoading }] = useGet(
    {
      route: "/companies",
      config: { params: { only_names: true } },
      defaultValue: { companies: [] }
    },
    []
  );
  return isLoading ? [] : companies;
}

// Handles axios errors by logging them and outputting an error string
function handleAxiosError(error) {
  if (error.response) {
    const { data } = error.response;
    const dataText =
      typeof data === "object" ? JSON.stringify(data) : data.toString();
    log(`${error.response.status} Error: ${dataText}`);
    return dataText;
  } else if (error.request) {
    log(`Client Error: ${JSON.stringify(error.request)}`);
    return "Could not make request. Check network connectivity";
  } else {
    log(`Generic Error: ${error.message}`);
    return error.message.toString();
  }
}

// Extends an axios config to add the header field
export function withAuthHeader({ config = {} }, token) {
  return {
    ...config,
    headers: {
      ...(isDefined(config.headers) ? config.headers : { Authorization: token })
    }
  };
}

// Dispatches a cancellable API request with the auth token added
export function performAuthRequest(
  route,
  method,
  token,
  { config = {}, ...rest }
) {
  const derivedConfig = withAuthHeader({ config }, token);
  return performRequest(route, method, { config: derivedConfig, ...rest });
}

// Dispatches a cancellable API request
export function performRequest(
  route,
  method,
  { onSuccess, onFailure, retry = true, config = {} }
) {
  const cancelRef = { current: false };
  const cancel = () => (cancelRef.current = true);
  const request = () => axios({ method, url: api(route), ...config });

  let promise = null;
  if (retry) {
    promise = retryPromise(request, {
      taskName: `${method.toUpperCase()} ${route}`,
      cancelRef: cancelRef
    });
  } else {
    promise = request();
  }

  promise
    .then(response => {
      if (!cancelRef.current) {
        onSuccess(response.data);
      }
    })
    .catch(error => {
      const errorText = handleAxiosError(error);
      if (!cancelRef.current) {
        log(`Request failed: ${method.toUpperCase()} ${route}`);
        onFailure(errorText);
      } else {
        log(`Silently ignoring error due to cancelled task: ${errorText}`);
      }
    });

  return cancel;
}

// Common use case where a resource is requested and is loaded
export function useGet(
  {
    route,
    retry = true,
    config = {},
    defaultValue = null,
    onFailure,
    onSuccess
  },
  dependencies = []
) {
  /* eslint-disable react-hooks/exhaustive-deps */
  const [result, update] = useState(defaultValue);
  const [isLoading, setIsLoading] = useState(false);
  useEffect(() => {
    setIsLoading(true);
    const cancel = performRequest(route, "get", {
      retry,
      config,
      onSuccess: data => {
        setIsLoading(false);
        update(data);
        if (isDefined(onSuccess)) onSuccess(data);
      },
      onFailure: error => {
        setIsLoading(false);
        if (isDefined(onFailure)) onFailure(error);
      }
    });

    // Cancel request upon cleaning up effect
    return cancel;
  }, dependencies);

  const refresh = useCallback(
    () =>
      performRequest(route, "get", {
        retry,
        config,
        onSuccess: data => {
          update(data);
        }
      }),
    [retry, config, route, update]
  );

  return [result, { isLoading, update, refresh }];
}

// Common use case where a resource is requested and is loaded
// (with auth headers automatically applied)
export function useAuthGet({ config = {}, ...rest }, dependencies) {
  const { token } = useAuth();
  const derivedConfig = withAuthHeader({ config }, token);
  return useGet({ config: derivedConfig, ...rest }, dependencies);
}

// Exposes loading, errors, and submission callback to API-enabled forms
export function useApiForm({
  path,
  show = true,
  onSuccess,
  onFailure,
  config = {}
}) {
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
  const onSubmit = data => {
    setIsLoading(true);
    axios({ url: api(path), method: "post", ...config, data })
      .then(response => {
        setIsLoading(false);
        clearErrors();
        onSuccess({ data, response: response.data });
      })
      .catch(error => {
        setIsLoading(false);
        const errorText = handleAxiosError(error);
        setError(errorText);
        if (isDefined(onFailure)) onFailure(errorText);
      });
  };

  return { errorContext, isLoading, onSubmit };
}

// Exposes loading, errors, and submission callback to API-enabled forms
// (with auth headers automatically applied)
export function useAuthForm({ config = {}, ...rest }) {
  const { token } = useAuth();
  const derivedConfig = withAuthHeader({ config }, token);
  return useApiForm({ config: derivedConfig, ...rest });
}
