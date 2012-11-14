require_relative "constants.rb"
require_relative "board.rb"


class Game
  
  def initialize
    @board = Board.new
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
  
end