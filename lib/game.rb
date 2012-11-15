require_relative "constants"
require_relative "board"


class Game
  
  def initialize
    @board = Board.new
  end
  
  def add_response(response)
    
    unless validate_input(response) 
      return true
    end
    
    return_value = true
    
    case response
    when NEW_GAME_RE then initialize_game
      
    when QUIT_GAME_RE 
      output(EXIT_MESSAGE) 
      return_value = false
    end
    
    return_value
  end
  
  def show
    @board.show
  end
  
  def move(token, position)
    @board.add(token,position)
  end
  
  def state
    @board.state
  end
  
  def initialize_game
    
    if ( human_first? )
      output(PLAYER_X_FIRST_MESSAGE)
    else
      output(PLAYER_O_FIRST_MESSAGE)
      move(X_TOKEN,generate_move)
    end
  end
  
  def validate_input(response)
    test_re = Regexp.union(NEW_GAME_RE,QUIT_GAME_RE)
    test_re = Regexp.union(test_re,MOVE_RANGE_RE) if ( :open == state )
    test_re =~ response and ( 1 == response.length )
  end
  
  def output(message)
    puts message
  end
  
  def human_first?
    ( 0 == rand(2) )
  end
  
end