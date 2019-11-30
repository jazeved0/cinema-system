import { isNil, isDefined } from "./object";
import zip from "lodash/zip";
import flatten from "lodash/flatten";

const domain = "cinema-system.ga";
const externalRegex = new RegExp(
  `^(?:(?:http|https):\\/\\/(?!(?:www\\.)?${domain})[\\w./=?#-_]+)|(?:mailto:.+)$`
);
export function isExternal(href) {
  return externalRegex.test(href);
}

const fileRegex = /^[\w./=:?#-]+[.]\w+$/;
export function isFile(href) {
  return fileRegex.test(href);
}

export function isEmptyOrNil(string) {
  if (typeof string !== "string") return isNil(string);
  return isNil(string) || string.trim().length === 0;
}

const logPrefix = "atlanta-movie";
export const log = message => console.log(`[${logPrefix}] ${message}`);
export const warn = message => console.warn(`[${logPrefix}] ${message}`);

export const addMissingUnit = dimension =>
  isNaN(dimension) ? dimension : `${dimension}px`;

export const multiplyDimension = (dimension, scalar) => {
  if (typeof dimension === "number") return dimension * scalar;
  else if (!isNaN(dimension)) return Number.parseFloat(dimension) * scalar;
  else {
    const dimensionRegex = /^([0-9]*\.?[0-9]*)([A-Za-z%]+)$/g;
    const matches = dimensionRegex.exec(dimension);
    return `${(Number.parseFloat(matches[1]) * scalar).toFixed(3)}${
      matches[2]
    }`;
  }
};

export function splitPath(path) {
  const trimmedPath = path.charAt(0) === "/" ? path.substr(1) : path;
  return (trimmedPath.slice(-1) === "/"
    ? trimmedPath.slice(0, -1)
    : trimmedPath
  ).split("/");
}

const BUILD_PATH_START_REGEX = /[/]*$/g;
const BUILD_PATH_REGEX = /(^[/]*|[/]*$)/g;
export function buildPath(...args) {
  return args
    .map((part, i) =>
      part
        .trim()
        .replace(i === 0 ? BUILD_PATH_START_REGEX : BUILD_PATH_REGEX, "")
    )
    .filter(x => x.length)
    .join("/");
}

export const collator = new Intl.Collator(undefined, {
  numeric: true,
  sensitivity: "base"
});

export function capitalize(s) {
  if (typeof s !== "string") return "";
  return s.charAt(0).toUpperCase() + s.slice(1);
}

export function pad(string, length) {
  return ("0" + string).slice(-length);
}

// ? ===============
// ? Regex functions
// ? ===============

export function splitFragments(string, regex) {
  const excludedFragments = string.split(regex);
  const matchedFragments = allMatches(string, regex);
  return flatten(zip(excludedFragments, matchedFragments)).filter(isDefined);
}

export function remakeRegex(source) {
  return new RegExp(source.source, source.flags);
}

export function allMatches(string, regex) {
  regex = remakeRegex(regex);
  let matches = [];
  let currentMatch;
  do {
    currentMatch = regex.exec(string);
    if (currentMatch) matches.push(currentMatch[0]);
  } while (currentMatch);
  return matches;
}
