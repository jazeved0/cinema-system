import { log } from "Utility/string";

export const identity = a => a;

export function retry(promise, timeout = 1000, taskName = "fetch") {
  return new Promise(resolve => {
    promise()
      .then(resolve)
      .catch(() => {
        setTimeout(() => {
          log(`Task failed: ${taskName}. Retrying...`);
          retry(promise, timeout).then(resolve);
        }, timeout);
      });
  });
}
