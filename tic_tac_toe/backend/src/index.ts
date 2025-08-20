import express from "express";
import { connectDB } from "./db/index_db";
import { createServer } from "http";
import { Server } from "socket.io";
import { roomModel } from "./models/room";

const app = express();
const port = process.env.PORT || 3000;
var httpServer = createServer(app);
var io = new Server(httpServer, {
  cors: {
    origin: "*",
    methods: ["GET", "POST"],
    credentials: false,
  },
});

app.use(express.json());

io.on("connection", (socket) => {
  console.log("Socket Connection Successful");
  socket.on("createRoom", async ({ nickname }) => {
    try {
      let room = new roomModel();
      let player = {
        socketID: socket.id,
        nickname: nickname,
        playerType: "X",
        points: 0,
      };
      room.players.push(player);
      room.turn = player;
      room = await room.save();
      const roomID = room._id.toString();
      socket.join(roomID);
      io.to(roomID).emit("createRoomSuccess", room);
    } catch (error) {
      console.log(error);
    }
  });
});

connectDB();

httpServer.listen(port, () => console.log(`Server running on port: ${port}`));
