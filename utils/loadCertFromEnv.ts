import fs from "node:fs";
import path from "node:path";
import { MissingCertEnvError, CertFileReadError } from "./errors";

export function loadCertFromEnv(varName: string): string {
  const filePath = process.env[varName];
  if (!filePath) {
    throw new MissingCertEnvError(varName);
  }

  const resolvedPath = path.resolve(filePath);

  try {
    return fs.readFileSync(resolvedPath, "utf8");
  } catch (err) {
    throw new CertFileReadError(varName, filePath, err as Error);
  }
}
