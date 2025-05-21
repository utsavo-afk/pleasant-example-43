export default async function Home() {
  const res = await fetch(process.env.API_BASE_URL + "/hello", {
    method: "GET",
    headers: {
      "Content-Type": "application/json",
    },
  });
  const data = await res.json();
  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2 overflow-hidden">
      <h1 className="text-4xl font-bold text-center">
        Nextjs + PNPM + Docker + Caddy + ec2
      </h1>
      <code>{data ? JSON.stringify(data) : "Loading..."}</code>
    </div>
  );
}
