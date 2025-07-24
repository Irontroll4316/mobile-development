import express from "express";
import authRouter from "./routes/auth_route";

const app = express();

app.use(express.json());
app.use('/auth', authRouter);

app.get('/', (req, res) => {
    res.send("hello");
});

app.listen(8000, () => {
    console.log("Server started on port 8000");
});