require_relative "grid"

class TreeNode
  attr_reader :value, :move
  
  def get_value(state)
    case state
    when :o_win then -1
    when :x_win then  1
    when :draw  then  0
    when :open  then  0
    else
      raise RuntimeError
    end
  end
  
end

# this will be for the O move

class MinNode < TreeNode
  
  def initialize(grid, min=-1, max=1)
    current = grid.state
    @value = get_value(current)
    
    minimax(grid,min,max) if (:open == current)
  end
  
  def minimax(grid, min, max)
    available_moves = grid.group_moves(O_TOKEN).shuffle
    @value = max
    current_move = nil
    
    available_moves.each do | next_group |
      new_grid = grid.dup
      new_grid.add(O_TOKEN,next_group[0])
      
      node = MaxNode.new(new_grid,min,@value)
      
      if ( node.value < @value)
        @value = node.value
        @move  = next_group.shuffle[0]
      else
        current_move = next_group.shuffle[0]
      end
      
      if ( @value <= min )
        @value = min
        break
      end
      
    end #each loop
    
    @move = current_move unless (@move)
    
  end
  
end

# this will be for the X move

class MaxNode < TreeNode

  def initialize(grid, min=-1, max=1)
    current = grid.state
    @value = get_value(current)
    
    minimax(grid,min,max) if ( :open == current )
  end
  
  def minimax(grid, min, max)
    available_moves = grid.group_moves(X_TOKEN).shuffle
    @value = min
    current_move = nil
    
    available_moves.each do | next_group |
      new_grid = grid.dup
      new_grid.add(X_TOKEN,next_group[0])
      node = MinNode.new(new_grid,@value,max)
      
      if ( node.value > @value)
        @move  = next_group.shuffle[0]
        @value = node.value
      else
        current_move = next_group.shuffle[0]
      end
      
      if ( @value >= max )
        @value = max
        break
      end
      
    end #each loop
    
    @move = current_move unless @move
    
  end
  
end