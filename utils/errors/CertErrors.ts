import { BaseError } from "./BaseError";

export class MissingCertEnvError extends BaseError {
  constructor(varName: string) {
    super(`Missing or invalid environment variable for cert: ${varName}`);
  }
}

export class CertFileReadError extends BaseError {
  constructor(varName: string, filePath: string, original: Error) {
    super(
      `Failed to read certificate file for ${varName} at ${filePath}: ${original.message}`
    );
  }
}
