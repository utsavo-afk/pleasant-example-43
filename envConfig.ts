import { loadEnvConfig } from "@next/env";

const projectDir = process.cwd();
const isDev = process.env.NODE_ENV === "development";

const customLogger = {
  info: console.log,
  warn: console.warn,
  error: console.error,
};

loadEnvConfig(projectDir, isDev, customLogger, true, (envPath) => {
  console.log(`Loading environment variables from ${envPath}`);
});
