import { UUID } from "crypto";
import {NextFunction, Request, Response} from "express";
import jwt from 'jsonwebtoken';
import { db } from "../db/index_db";
import { users } from "../db/schema";
import { eq } from 'drizzle-orm';

export interface AuthRequest extends Request {
  user?: UUID;
  token?: string;
}

export const auth = async (req: AuthRequest, res: Response, next: NextFunction) => {
  try {
    const token = req.header("x-auth-token");
    if (!token) return res.status(401).json({error: "No Auth Token"});
    const verified = jwt.verify(token, "passwordKey");
    if (!verified) return res.status(401).json({error: "Token Verification Failed"});
    const verifiedToken = verified as {id: UUID};
    const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));
    if (!user) return res.status(401).json({error: "User not Found"});
    req.user = verifiedToken.id;
    req.token = token;
    next();
  } catch (e) {
    res.status(500).json({error: e});
  }
}