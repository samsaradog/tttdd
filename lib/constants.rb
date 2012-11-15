

INITIAL_BOARD = " 0 | 1 | 2 \n" +
                "-----------\n" +
                " 3 | 4 | 5 \n" +
                "-----------\n" +
                " 6 | 7 | 8 \n"
                
X_TOKEN = "X"
O_TOKEN = "O"

Z_TOKEN = "Z"

PLAYER_X_FIRST_MESSAGE = "Human moves first\n"
PLAYER_O_FIRST_MESSAGE = "Computer moves first\n"

EXIT_MESSAGE = "Thank you for playing!\n"

NEW_GAME_RE   = /y/i
QUIT_GAME_RE  = /[qxn]/i
MOVE_RANGE_RE = /[0-8]/
