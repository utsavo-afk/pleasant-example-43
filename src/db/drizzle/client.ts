import "@project/envConfig";
import { drizzle } from "drizzle-orm/node-postgres";
import { Pool } from "pg";
import * as schema from "./schema/index";
import { loadCertFromEnv } from "@project/utils";
import tls from "tls";

const client = new Pool({
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
});

export const db = drizzle(client, { schema });
