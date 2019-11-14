const identity = x => x;
export function invertMap(map, f = identity) {
  return Object.keys(map).reduce(function(acc, k) {
    acc[map[k]] = (acc[map[k]] || []).concat(f(k));
    return acc;
  }, {});
}

export function isNil(object) {
  return object == null;
}

export function isDefined(object) {
  return !isNil(object);
}

export function isIterable(obj) {
  return isDefined(obj) && typeof obj[Symbol.iterator] === "function";
}
