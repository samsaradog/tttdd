require_relative "constants"
require_relative "board"

class Game
  
  def initialize
    @board = Board.new
  end
  
  def run
    initialize_game
    
    while(1)
      display
      break unless add_response(input)
    end
  end
  
  def add_response(response)
    unless validate_input(response) 
      output(BAD_INPUT_MESSAGE+response+"\n")
      return true
    end
    
    return_value = true
    
    case response
    when NEW_GAME_RE then initialize_game
      
    when QUIT_GAME_RE 
      output(EXIT_MESSAGE) 
      return_value = false
    
    when MOVE_RANGE_RE
      begin
        move(O_TOKEN,response)
      rescue
        output(response+MOVE_TAKEN_MESSAGE)
      else
        move(X_TOKEN,generate_x_move) if (:open == state)
      end
      
    end
  
    return_value
  end
  
  def generate_x_move
    @board.generate_x_move
  end
  
  def board
    @board.show
  end
  
  def prompt
    if (:open == state)
      MOVE_MESSAGE
    else
      GAME_COMPLETED_MESSAGE
    end
  end
  
  def notification
    
    case state
    when :draw  then DRAW_GAME_MESSAGE
    when :x_win then X_WINS_MESSAGE
    when :o_win then O_WINS_MESSAGE
    end
  end
  
  def display
    output(notification)
    output(board)
    output(prompt)
  end
  
  def move(token, position)
    @board.add(token,position)
  end
  
  def state
    @board.state
  end
  
  def initialize_game
    @board = Board.new
    
    if ( human_first? )
      output(PLAYER_O_FIRST_MESSAGE)
    else
      output(PLAYER_X_FIRST_MESSAGE)
      move(X_TOKEN,generate_x_move)
    end
  end
  
  def validate_input(response)
    test_re = Regexp.union(NEW_GAME_RE,QUIT_GAME_RE)
    test_re = Regexp.union(test_re,MOVE_RANGE_RE) if ( :open == state )
    test_re =~ response and ( 1 == response.length )
  end
  
  def input
    gets.chomp
  end
  
  def output(message)
    puts message
  end
  
  def human_first?
    ( 0 == rand(2) )
  end
  
end