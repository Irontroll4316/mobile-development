import express from "express";
import authRouter from "./routes/auth_route";
import taskRouter from "./routes/task_route";

const app = express();

app.use(express.json());
app.use('/auth', authRouter);
app.use('/tasks', taskRouter);

app.get('/', (req, res) => {
    res.send("hello");
});

app.listen(8000, () => {
    console.log("Server started on port 8000");
});