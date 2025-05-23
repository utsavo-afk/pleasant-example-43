import { bigserial, pgTable, timestamp, varchar } from "drizzle-orm/pg-core";
import { createInsertSchema, createSelectSchema } from "drizzle-zod";
import { z } from "zod/v4";

export const posts = pgTable("posts", {
  id: bigserial({ mode: "number" }).primaryKey(),
  title: varchar("title", { length: 255 }).notNull(),
  createdAt: timestamp("created_at", {
    withTimezone: true,
    mode: "date",
    precision: 0,
  }).defaultNow(),
});

export const InsertPostSchema = createInsertSchema(posts, {
  title: (schema) => schema.nonempty(),
}).omit({
  id: true,
  createdAt: true,
});
export const SelectPostSchema = createSelectSchema(posts);

// Types
export type Post = z.infer<typeof SelectPostSchema>;
export type NewPost = z.infer<typeof InsertPostSchema>;
