require_relative "constants"
require_relative "grid"
require_relative "brain"


BOARD_TO_GRID = {  "0" => 0, "1" => 1, "2" => 2,
                   "3" => 7, "4" => 8, "5" => 3,
                   "6" => 6, "7" => 5, "8" => 4 }

GRID_TO_BOARD = BOARD_TO_GRID.invert

class Board
  attr_reader :state
  
  def initialize
    @grid  = Grid.new
    @state = :open
  end
  
  def add!(token,position)
    grid_position = BOARD_TO_GRID[position]
    @grid.add!(token,grid_position)

    @state = grid_state
  end
  
  def show
    display = INITIAL_BOARD.dup
    
    [X_TOKEN,O_TOKEN].each do |token|
      grid_moves = @grid.find_moves(token)
      grid_moves.each do |grid_move|
        display_move = GRID_TO_BOARD[grid_move]
        display.sub!(%r(#{display_move}),token)
      end
    end
    
    display
  end
  
  def grid_state
    @grid.state
  end
  
  def generate_x_move
    GRID_TO_BOARD[Brain.x_move(@grid)]
  end
  
end