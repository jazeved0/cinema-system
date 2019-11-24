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

export function isArray(obj) {
  return isDefined(obj) && typeof obj === "object" && Array.isArray(obj);
}

export function createObject() {
  return Object.create(null);
}

export function equal(a, b) {
  if (a instanceof Array && b instanceof Array) {
    if (a.length !== b.length) return false;
    else {
      for (let i = 0; i < a.length; i++) {
        if (!equal(a[i], b[i])) return false;
      }
      return true;
    }
  } else {
    return a === b;
  }
}

const SNAKE_CASE_REGEX = /([-_][a-z])/gi;
export function snakeToCamelCase(a) {
  if (isDefined(a)) {
    if (typeof a === "object") {
      let built = {};
      for (const key in a) {
        if (a.hasOwnProperty(key)) {
          built[snakeToCamelCase(key)] = a[key];
        }
      }
      return built;
    } else if (typeof a === "string") {
      return a.replace(SNAKE_CASE_REGEX, $1 => {
        return $1
          .toUpperCase()
          .replace("-", "")
          .replace("_", "");
      });
    }
  }

  return a;
}
