import "@project/envConfig";
import { defineConfig } from "drizzle-kit";
import { loadCertFromEnv } from "@project/utils";
import tls from "tls";

const drizzleSchemaPath = process.cwd() + "/src/db/drizzle/schema/*";
const drizzleMigrationsPath = process.cwd() + "/src/db/drizzle/migrations";

export default defineConfig({
  schema: drizzleSchemaPath,
  out: drizzleMigrationsPath,
  dialect: "postgresql",
  dbCredentials: {
    host: process.env.POSTGRES_HOST!,
    port: parseInt(process.env.POSTGRES_PORT!),
    user: process.env.POSTGRES_USER!,
    password: process.env.POSTGRES_PASSWORD!,
    database: process.env.POSTGRES_DB!,
    ssl: {
      rejectUnauthorized: true,
      requestCert: true,
      checkServerIdentity: (hostname, cert) => {
        return tls.checkServerIdentity(hostname, cert);
      },
      ca: loadCertFromEnv("POSTGRES_SSL_ROOT_CERT"),
      cert: loadCertFromEnv("POSTGRES_SSL_CLIENT_CERT"),
      key: loadCertFromEnv("POSTGRES_SSL_CLIENT_KEY"),
    },
  },
  verbose: true,
  strict: true,
});
