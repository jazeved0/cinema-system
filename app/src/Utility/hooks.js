import { useEffect, useRef, useCallback, useMemo, useState } from "react";
import { addMissingUnit, collator } from "./string";

// Runs an effect hook once, simulating componentDidMount/componentWillUnmount
export function useEffectOnce(effectFunc) {
  useEffect(effectFunc, []);
}

// Runs effect upon rising edge of boolean condition
export function useRisingEdge(condition, effect) {
  /* eslint-disable react-hooks/exhaustive-deps */
  useEffect(() => {
    if (!condition) return effect;
  }, [condition]);
}

// Runs effect upon falling edge of boolean condition
export function useFallingEdge(condition, effect) {
  /* eslint-disable react-hooks/exhaustive-deps */
  useEffect(() => {
    if (!!condition) return effect;
  }, [condition]);
}

export function useMemoRef(memoFunc, deps, default_value = null) {
  /* eslint-disable react-hooks/exhaustive-deps */
  const ref = useRef(default_value);
  useEffect(() => (ref.current = memoFunc), deps);
  return ref;
}

export function useCallbackOnce(func) {
  return useCallback(func, []);
}

// Return index of the current min-width breakpoint from the given breakpoints
// array, or -1 if none are active
export function useMediaBreakpoints(breakpoints) {
  const sortedBreakpoints = useMemo(
    () => [...breakpoints].sort(collator.compare),
    [breakpoints]
  );

  const queries = useMemo(
    () => sortedBreakpoints.map(b => `(min-width: ${addMissingUnit(b)})`),
    [sortedBreakpoints]
  );

  const getBreakpoint = useCallback(
    matches => {
      // Find first media query that fails
      const result = matches.findIndex(m => !m);
      // If none fail, then return last breakpoint; else return the last passing
      return result === -1 ? sortedBreakpoints.length - 1 : result - 1;
    },
    [sortedBreakpoints]
  );

  const [state, setState] = useState(() =>
    getBreakpoint(queries.map(q => window.matchMedia(q).matches))
  );

  useEffect(() => {
    let mounted = true;
    const mediaQueries = queries.map(q => window.matchMedia(q));
    const onChange = () => {
      if (!mounted) {
        return;
      }
      setState(getBreakpoint(mediaQueries.map(m => m.matches)));
    };

    mediaQueries.forEach(mql => mql.addListener(onChange));
    setState(getBreakpoint(mediaQueries.map(m => m.matches)));

    return () => {
      mounted = false;
      mediaQueries.forEach(mql => mql.removeListener(onChange));
    };
  }, [getBreakpoint, queries]);

  return state === -1 ? null : sortedBreakpoints[state];
}
