import { seed } from "drizzle-seed";
import { db } from "./client";
import * as schema from "./schema";

export async function seedDatabase() {
  await seed(db, schema).refine((f) => ({
    posts: {
      count: 20,
      columns: {
        title: f.jobTitle(),
      },
    },
  }));
}

seedDatabase();
