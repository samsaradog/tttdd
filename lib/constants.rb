

INITIAL_BOARD = " 0 | 1 | 2 \n" +
                "-----------\n" +
                " 3 | 4 | 5 \n" +
                "-----------\n" +
                " 6 | 7 | 8 \n"
                
X_TOKEN = "X"
O_TOKEN = "O"

Z_TOKEN = "Z"

PLAYER_X_FIRST_MESSAGE = "Computer moves first\n"
PLAYER_O_FIRST_MESSAGE = "Human moves first\n"

DRAW_GAME_MESSAGE = "Draw Game"
X_WINS_MESSAGE    = "X is the Winner!"
O_WINS_MESSAGE    = "O is the Winner!"

EXIT_MESSAGE = "Thank you for playing!\n"

MOVE_TAKEN_MESSAGE = " not available. Please choose another\n"
BAD_INPUT_MESSAGE = "Sorry, I don't understand "

MOVE_MESSAGE = "Please choose 0-8 to move,\n" +
               "Y for a new game or Q to quit.\n"
               
GAME_COMPLETED_MESSAGE = "Would you like to play again? (Y/N)"

NEW_GAME_RE   = /y/i
QUIT_GAME_RE  = /[qxn]/i
MOVE_RANGE_RE = /[0-8]/
