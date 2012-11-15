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
  
  def ==(other)
    ( @center == other.center ) && ( @outside == other.outside )
  end
  
  def dup
    return_value = Grid.new
    return_value.center.merge!(@center)
    return_value.outside.merge!(@outside)
    return_value
  end
  
  def add(token,position)
    raise RangeError unless in_range?(position)
    raise RuntimeError unless ( 0 != available.count(position))
    
    if ( CENTER_POSITION == position )
      @center[CENTER_POSITION] = token
    else
      @outside[position] = token
    end
  end
  
  def in_range?(position)
    position.to_s =~ /[0-8]/
  end
  
  def available
    has_moved(Z_TOKEN)
  end
  
  def grid_full?
    available.empty?
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
    game_winner?(has_moved(token))
  end
  
  def has_moved(token)
    h = @outside.merge(@center)
    h.select { |k,v| token == v }.keys
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
  
  def match(other)
    return -1 if @center != other.center
    
    (1..3).each do |x|
      rotated = rotate(other.outside, x)
      return x if ( rotated == @outside )
    end
    -1
  end
  
  def adjust_keys(source,count,target)
    source.each { |k,v| target[(k+(count*2)) % OUTSIDE_SIZE] = v }
  end
  
  def rotate(moves,count)
    return_value = {}
    adjust_keys(moves,count,return_value)
    return_value
  end
  
  def rotate!(count)
    new_hash = {}
    adjust_keys(@outside,count,new_hash)
    @outside.replace(new_hash)
  end
  
  def group_moves(token)
    available_moves = available
    buckets = []
    
    available_moves.each do |move|
      new_grid = dup
      new_grid.add(token,move)
      
      buckets << [move] unless update_buckets(token,new_grid,move,buckets)
    end
    buckets
    
  end
  
  def update_buckets(token,grid,move,buckets)
    return_value = false
    
    buckets.each do |bucket|
      bucket_grid = dup
      bucket_grid.add(token,bucket[0])

      if ( 0 <= grid.match(bucket_grid))
        found = true
        bucket << move
      end
    end
    
    return_value
  end
  
end