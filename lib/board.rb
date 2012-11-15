require_relative "constants"
require_relative "grid.rb"

GRID_TRANSLATION = {  "0" => 0, "1" => 1, "2" => 2,
                      "3" => 7, "4" => 8, "5" => 3,
                      "6" => 6, "7" => 5, "8" => 4 }

class Board
  attr_reader :state
  
  def initialize
    @grid  = Grid.new
    @state = :open
  end
  
  def add(token,position)
    grid_position = GRID_TRANSLATION[position]
    @grid.add(token,grid_position)

    @state = check_state
  end
  
  def show
    display = INITIAL_BOARD.dup
    inverted = GRID_TRANSLATION.invert
    
    [X_TOKEN,O_TOKEN].each do |token|
      grid_moves = @grid.has_moved(token)
      grid_moves.each do |grid_move|
        display_move = inverted[grid_move]
        display.sub!(%r(#{display_move}),token)
      end
    end
    
    display
  end
  
  def check_state
    @grid.state
  end
  
end