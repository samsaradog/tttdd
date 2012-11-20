require_relative "constants"
require_relative "board"

class Game
  
  def initialize
    @board = Board.new
    @state_params = OpenGameParams.new
  end
  
  def run
    initialize_game
    
    while(1)
      display
      break unless keep_playing?(input)
    end
  end
  
  def keep_playing?(response)
    unless validate_input(response) 
      output(BAD_INPUT_MESSAGE+response+"\n")
      return true
    end
    
    case response
    when QUIT_GAME_RE  then return (output(EXIT_MESSAGE) or false)
    when NEW_GAME_RE   then initialize_game
    when MOVE_RANGE_RE then process_move(response)
    end
  
    true
  end
  
  def process_move(response) #state specific
    begin
      move(O_TOKEN,response)
    rescue
      output(response+MOVE_TAKEN_MESSAGE)
    else
      move(X_TOKEN,generate_x_move) if (:open == state)
    end
  end
  
  def generate_x_move
    @board.generate_x_move
  end
  
  def board
    @board.show
  end
  
  def prompt #state specific
    @state_params.prompt
  end
  
  def notification # state specific
    STATE_TO_NOTIFICATION[state]
  end
  
  def move(token, position) # state can change here
    @board.add!(token,position)
    @state_params = EndGameParams.new unless (:open == state)
  end
  
  def state
    @board.state
  end
  
  def initialize_game # state can change here
    @board = Board.new
    
    if ( human_first? )
      output(PLAYER_O_FIRST_MESSAGE)
    else
      output(PLAYER_X_FIRST_MESSAGE)
      move(X_TOKEN,generate_x_move)
    end
    
    @state_params = EndGameParams.new unless (:open == state)
  end
  
  def validate_input(response)
    @state_params.validation_re =~ response and ( 1 == response.length )
  end
  
  def display
    output(notification)
    output(board)
    output(prompt)
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

class OpenGameParams
  def prompt
    MOVE_MESSAGE
  end
  
  def validation_re
    Regexp.union(NEW_GAME_RE,QUIT_GAME_RE,MOVE_RANGE_RE)
  end
end

class EndGameParams
  def prompt
    GAME_COMPLETED_MESSAGE
  end
  
  def validation_re
    Regexp.union(NEW_GAME_RE,QUIT_GAME_RE)
  end
end
