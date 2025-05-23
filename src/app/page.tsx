export default async function Home() {
  // const data = (await db.query.posts.findFirst({})) as Post;
  // console.log(data);

  const res = await fetch("https://jsonplaceholder.typicode.com/posts/1", {
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
      <code>{data ? JSON.stringify(data, null, 2) : "Loading..."}</code>
    </div>
  );
}
