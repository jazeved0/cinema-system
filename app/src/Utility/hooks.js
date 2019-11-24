import { useEffect } from "react";

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
