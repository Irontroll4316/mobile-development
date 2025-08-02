import { Router } from "express";
import { auth, AuthRequest } from '../middleware/auth_middleware';
import { db } from "../db/index_db";
import { eq } from 'drizzle-orm';
import { NewTemplate, Template, templates } from "../db/schema";

const templateRouter = Router();

templateRouter.post("/", auth, async(req: AuthRequest, res) => {
  try {
    req.body = {...req.body, uid: req.user!};
    const newtemplate: NewTemplate = req.body;
    const [template] = await db.insert(templates).values(newtemplate).returning();
    res.status(201).json(template);
    } catch (e) {
    res.status(500).json({error: e});
  }
});

templateRouter.get("/", auth, async(req: AuthRequest, res) => {
  try {
    const alltemplates = await db.select().from(templates).where(eq(templates.uid, req.user!));
    res.json(alltemplates);
    } catch (e) {
    res.status(500).json({error: e});
  }
});

templateRouter.delete("/", auth, async(req: AuthRequest, res) => {
  try {
    const {templateName}: {templateName: string} = req.body;
    await db.delete(templates).where(eq(templates.name, templateName));
    res.json(true);
    } catch (e) {
    res.status(500).json({error: e});
  }
});

templateRouter.post("/sync", auth, async(req: AuthRequest, res) => {
  try {
    const templatesList = req.body;
    const filteredtemplates: NewTemplate[] = [];  
    for(let t of templatesList) {
      t = {...t, createdAt: new Date(t.createdAt), lastUsed: new Date(t.updatedAt), uid: req.user};
      filteredtemplates.push(t);
    }
    const pushedtemplates = await db.insert(templates).values(filteredtemplates).returning();
    res.status(201).json(pushedtemplates);
  } catch (e) {
    res.status(500).json({error: e});
  }
});

templateRouter.post("/use", auth, async(req: AuthRequest, res) => {
  try {
    const template: Template = req.body;
    await db.update(templates).set({lastUsed: new Date(Date.now())}).where(eq(templates.name, template.name));
    res.status(201).json(true);
  } catch (e) {
    res.status(500).json({error: e});
  }
})

export default templateRouter;