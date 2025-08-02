import { pgTable, text, timestamp, uuid, integer } from "drizzle-orm/pg-core";

export const users = pgTable("users", {
    id: uuid("id").primaryKey().defaultRandom(),
    name: text("name").notNull(),
    email: text("email").notNull().unique(),
    password: text("password").notNull(),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
});

export type User = typeof users.$inferSelect;
export type NewUser = typeof users.$inferInsert;

export const tasks = pgTable("tasks", {
    id: uuid("id").primaryKey().defaultRandom(),
    title: text("title").notNull(),
    description: text("description").notNull(),
    color: text("color").notNull(),
    uid: uuid("uid").notNull().references(() => users.id, {onDelete: "cascade"}),
    dueAt: timestamp("due_at").$defaultFn(() => new Date(Date.now() + 7 * 24 * 60 * 60 * 1000)),
    createdAt: timestamp("created_at").defaultNow(),
    updatedAt: timestamp("updated_at").defaultNow(),
    completed: integer("completed").default(0),
});

export type Task = typeof tasks.$inferSelect;
export type NewTask = typeof tasks.$inferInsert;

export const templates = pgTable("templates", {
    name: text("name").primaryKey(),
    color: text("color").notNull(),
    createdAt: timestamp("created_at").defaultNow(),
    lastUsed: timestamp("last_used").defaultNow(),
    uid: uuid("uid").notNull().references(() => users.id, {onDelete: "cascade"}),
});

export type Template = typeof templates.$inferSelect;
export type NewTemplate = typeof templates.$inferInsert;