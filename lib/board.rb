require_relative "constants.rb"

class Board
  attr_reader :state
  
  def initialize
    @moves = INITIAL_BOARD.dup
    @state = :open
  end
  
  def add(token,position)
    raise RangeError unless in_range?(position)
    raise RuntimeError unless available?(position)

    @moves.sub!(%r(#{position}),token)

    @state = check_state
  end
  
  def show
    @moves
  end
  
  def in_range?(position)
    position =~ /[0-8]/
  end
  
  def available?(position)
    @moves =~ /#{position}/
  end
  
  def full?
    @moves !~ /[0-8]/
  end
  
  def check_state
    return :draw if full?
    return :x_win if winner?(X_TOKEN)
  end
  
  def winner?(token)
    false
  end
  
end