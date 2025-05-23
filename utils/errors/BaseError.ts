export class BaseError extends Error {
  public readonly isOperational: boolean;

  constructor(message: string) {
    super(message);
    this.name = new.target.name; // Dynamic class name
    this.isOperational = true;

    // Captures correct stack trace excluding constructor call
    if (Error.captureStackTrace) {
      Error.captureStackTrace(this, new.target);
    }
  }
}
