require_relative "constants.rb"

class Brain
  def initialize
    
  end
  
  def best_move(grid)
    o_moved = grid.has_moved(O_TOKEN)
    available_moves = grid.available
    
    available_moves.each do |move|
      return move if ( grid.game_winner?(o_moved + [move]))
    end
    -1
  end
end
