import "dart:io";
import "dart:math";
enum Move { rock, paper, scissors }

void main()
{
  final rng = Random();
  // Game Loop
  while(true)
  {
    // Get user input
    stdout.write("Rock, Paper, or Scissors? (r, p, s) (Press q to quit): ");
    final input = stdin.readLineSync();

    // Validate input
    if (input == 'r' || input == 'p' || input == 's')
    {
      // Get player's move
      var playerMove;
      if (input == 'r')
      {
        playerMove = Move.rock;
      } else if (input == 'p')
      {
        playerMove = Move.paper;
      } else if (input == 's')
      {
        playerMove = Move.scissors;
      }
      // Get ai's move
      final random = rng.nextInt(3);
      final aiMove = Move.values[random];

      if (playerMove == aiMove)
      {
        print("It's a Draw!");
      } else if (playerMove == Move.rock && aiMove == Move.scissors ||
                 playerMove == Move.paper && aiMove == Move.rock ||
                 playerMove == Move .scissors && aiMove == Move.paper)
      {
        print("You played: $playerMove and the computer played: $aiMove");
        print("You Win!");
      } else 
      {
        print("You played: $playerMove and the computer played: $aiMove");
        print("You Lose!");
      }

    } else if (input == 'q')
    {
      break;
    } else
    {
      print("Invalid Input! Try Again!");
    }
  }
}
