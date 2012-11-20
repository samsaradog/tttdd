require_relative "constants"

CENTER_POSITION = 8
OUTSIDE_SIZE    = 8

class Grid
  attr_reader :center, :outside
  
  def initialize
    @outside = {}
    (0..7).to_a.each { |x| @outside[x] = Z_TOKEN }
    @center = { CENTER_POSITION => Z_TOKEN }
  end
  
  def add!(token,position)
    raise RangeError unless in_range?(position)
    raise RuntimeError unless ( 0 != available.count(position))
    
    if ( CENTER_POSITION == position )
      @center[position] = token
    else
      @outside[position] = token
    end
    self
  end
  
  def dup
    return_value = Grid.new
    return_value.center.merge!(center)
    return_value.outside.merge!(outside)
    return_value
  end
  
  def ==(other)
    ( center == other.center ) && ( outside == other.outside )
  end
  
  def match?(other) 
    return false if center != other.center
    
    (1..3).each do |x|
      rotated = rotate(other.outside, x)
      return true if ( rotated == outside )
    end
    false
  end
  
  def rotate(moves,count) 
    return_value = {}
    moves.each { |k,v| return_value[(k+(count*2)) % OUTSIDE_SIZE] = v }
    return_value
  end
  
  def in_range?(position)
    position.to_s =~ /[0-8]/
  end
  
  def grid_full?
    available.empty?
  end
  
  def available
    find_moves(Z_TOKEN)
  end
  
  def is_draw?
    :draw == state
  end
  
  def state
    return :x_win if has_winner?(X_TOKEN)
    return :o_win if has_winner?(O_TOKEN)
    return :draw  if grid_full?
    :open
  end
  
  def has_winner?(token)
    game_winner?(find_moves(token))
  end
  
  def find_moves(token)
    h = @outside.merge(center)
    h.select { |k,v| token == v }.keys
  end
  
  def group_moves(token)
    buckets = []
    
    available.each do |move|
      new_grid = self.dup.add!(token,move)
      buckets << [move] unless updated_buckets?(token,new_grid,move,buckets)
    end
    
    buckets.shuffle
  end
  
  def updated_buckets?(token,new_grid,move,buckets) #transparent
    return_value = false
    
    buckets.each do |bucket|
      if new_grid.match?(self.dup.add!(token,bucket[0]))
        bucket << move
        return_value = true
        break
      end
    end
    
    return_value
  end
  
  def game_winner?(moves)
    edge_winner?(moves - [CENTER_POSITION]) || cross_winner?(moves)
  end
  
  def edge_winner?(moves)
    moves.each do |x|
      next if ( 0 != (x % 2))
      next unless moves.include?((x+1) % OUTSIDE_SIZE)
      next unless moves.include?((x+2) % OUTSIDE_SIZE)
      return true
    end
    false
  end
  
  def cross_winner?(moves)
    return false unless moves.include?(CENTER_POSITION)
    
    outside_moves = moves - [CENTER_POSITION]
    
    outside_moves.each do |x|
      next unless outside_moves.include?((x+4) % OUTSIDE_SIZE)
      return true
    end
    
    false
  end
  
end