import mongoose from "mongoose";

const connectionString =
  "mongodb+srv://irontroll4316:tictactoe@tic-tac-toe.lofsgmy.mongodb.net/?retryWrites=true&w=majority&appName=Tic-Tac-Toe";

export const connectDB = async () => {
  try {
    await mongoose.connect(connectionString);
    console.log("Database Connection Successful");
  } catch (e) {
    console.log(`Error in connecting to MongoDB:\n${e}`);
  }
};
