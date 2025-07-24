import {Router, Request, Response} from 'express';
import { db } from '../db/index_db';
import { NewUser, users } from '../db/schema';
import { eq } from 'drizzle-orm';
import bcryptjs from 'bcryptjs';
import jwt from "jsonwebtoken";
import { auth, AuthRequest } from '../middleware/auth_middleware';

const authRouter = Router();

interface SignUpBody {
    name: string;
    email: string;
    password: string;
}

interface LogInBody {
    email: string;
    password: string;
}

authRouter.post("/signup", async (req: Request<{}, {}, SignUpBody>, res: Response) => {
    try {
        // Get user from db and check if they exist
        const {name, email, password} = req.body;
        const existingUser = await db.select().from(users).where(eq(users.email, email));
        if (existingUser.length) {
            res.status(400).json({error: "User with email already exists"});
            return;
        }
        // Encrpt password and create user
        const hashedPassword = await bcryptjs.hash(password, 8);
        const newUser: NewUser = {
            name,
            email,
            password: hashedPassword,
        };
        const [user] = await db.insert(users).values(newUser).returning()
        res.status(201).json(user);
    } catch (e) {
        res.status(500).json({error: e});
    }
});

authRouter.post("/login", async (req: Request<{}, {}, LogInBody>, res: Response) => {
    try {
        // Get user from db and check if they do not exist
        const {email, password} = req.body;
        const [existingUser] = await db.select().from(users).where(eq(users.email, email));
        if (!existingUser) {
            res.status(400).json({error: "Email or password in invalid"});
            return;
        }

        const isMatch = await bcryptjs.compare(password, existingUser.password);
        if (!isMatch) {
            res.status(400).json({error: "Email or password is invalid"});
            return;
        }
        const token = jwt.sign({id: existingUser.id}, "passwordKey");
        res.json({token, ...existingUser});
        
    } catch (e) {
        res.status(500).json({error: e});
    }
});

authRouter.post("/tokenIsValid", async (req, res) => {
    try {
        const token = req.header("x-auth-token");
        if (!token) return res.json(false);
        const verified = jwt.verify(token, "passwordKey");
        if (!verified) return res.json(false);
        const verifiedToken = verified as {id: string};
        const [user] = await db.select().from(users).where(eq(users.id, verifiedToken.id));
        if (!user) return res.json(false);
        res.json(true);
    } catch (e) {
        res.status(500).json(false);
    }
});

authRouter.get("/", auth, async (req: AuthRequest, res) => {
    console.log(req.user);
    try {
        if (!req.user) {
            res.status(401).json({error: "User not found!"});
            return;
        }
        const [user] = await db.select().from(users).where(eq(users.id, req.user));
        res.json({...user, token: req.token});
    } catch (e) {
        res.status(500).json(false);
    }  
});

export default authRouter;