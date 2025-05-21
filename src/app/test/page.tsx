"use client";

import { useEffect, useState } from "react";

export default function Page() {
  const [fetchData, setFetchData] = useState("");

  useEffect(() => {
    async function fetchData() {
      const res = await fetch(process.env.NEXT_PUBLIC_API_URL + "/hello", {
        method: "GET",
        headers: {
          "Content-Type": "application/json",
        },
      });
      const data = await res.json();
      console.log(data);
      setFetchData(data);
    }
    fetchData();
  }, []);
  return (
    <div className="flex flex-col items-center justify-center min-h-screen py-2 overflow-hidden">
      <h1 className="text-4xl font-bold text-center">Test Page Yoooo</h1>
      <code>{fetchData ? JSON.stringify(fetchData) : "Loading..."}</code>
    </div>
  );
}
