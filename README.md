This is a [Next.js](https://nextjs.org) project bootstrapped with [`create-next-app`](https://nextjs.org/docs/app/api-reference/cli/create-next-app).

## Getting Started

First, run the development server:

```bash
npm run dev
# or
yarn dev
# or
pnpm dev
# or
bun dev
```

Open [http://localhost:3000](http://localhost:3000) with your browser to see the result.

You can start editing the page by modifying `app/page.tsx`. The page auto-updates as you edit the file.

This project uses [`next/font`](https://nextjs.org/docs/app/building-your-application/optimizing/fonts) to automatically optimize and load [Geist](https://vercel.com/font), a new font family for Vercel.

## Learn More

To learn more about Next.js, take a look at the following resources:

- [Next.js Documentation](https://nextjs.org/docs) - learn about Next.js features and API.
- [Learn Next.js](https://nextjs.org/learn) - an interactive Next.js tutorial.

You can check out [the Next.js GitHub repository](https://github.com/vercel/next.js) - your feedback and contributions are welcome!

## Deploy on Vercel

The easiest way to deploy your Next.js app is to use the [Vercel Platform](https://vercel.com/new?utm_medium=default-template&filter=next.js&utm_source=create-next-app&utm_campaign=create-next-app-readme) from the creators of Next.js.

Check out our [Next.js deployment documentation](https://nextjs.org/docs/app/building-your-application/deploying) for more details.

### mTLS server + nextjs client

<pre>
```text
[Next.js Server] ─── CONNECT ───► [PostgreSQL Server]
     |
     | 1. Verifies the PostgreSQL server cert using:
     |    └── ✅ POSTGRES_SSL_ROOT_CERT (root.crt)
     |
     | 2. (Optional) Sends its own client cert if required:
     |    └── ✅ POSTGRES_SSL_CLIENT_CERT (client.crt)
     |    └── ✅ POSTGRES_SSL_CLIENT_KEY  (client.key)
     |
     ▼

[PostgreSQL Server] ◄── VERIFIES ──┐
     |                             └── If mTLS is enabled:
     |                                 - Validates client cert
     |                                 - Uses root CA that signed the client cert
```
</pre>

### ✅ Full Lifecycle of a TLS Session

1. 🔐 Next.js ➡️ Postgres: Client connects
2. 📜 Postgres presents `server.crt`
3. ✅ Next.js validates it against `root.crt`
4. (Optional) 🪪 Next.js presents `client.crt`, `client.key`
5. 🔑 Session key is negotiated (TLS handshake complete)
6. 🔁 All data (both directions) is encrypted using this shared session key
7. 🔽 Data flows back from Postgres to Next.js securely
