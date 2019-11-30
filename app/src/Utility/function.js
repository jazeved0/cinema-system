import { log } from "Utility/string";

export const identity = a => a;

export function retry(promise, args) {
  const {
    timeout = 2000,
    taskName = "fetch",
    cancelRef = { current: false }
  } = args;
  return new Promise(resolve => {
    promise()
      .then(resolve)
      .catch(() => {
        log(`Task failed: ${taskName}. Retrying in ${timeout} ms...`);
        setTimeout(() => {
          if (!cancelRef.current) {
            retry(promise, args).then(resolve);
          }
        }, timeout);
      });
  });
}
