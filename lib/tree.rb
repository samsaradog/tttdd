require_relative "grid"

class TreeNode
  attr_reader :value, :move
  
  def initialize(grid,min,max)
    @current_state = grid.state
    @value = get_value_from_state(@current_state)
    minimax(grid,min,max) if (:open == @current_state)
  end
  
  def get_value_from_state(state)
    case state
    when :o_win then -1
    when :x_win then  1
    when :draw  then  0
    when :open  then  0
    else
      raise RuntimeError
    end
  end
  
  def minimax(grid,min,max)
    available_moves = grid.group_moves(token)
    
    @value = get_limit_value(min,max)
    next_move = nil 
    
    available_moves.each do | current_group |
      next_move = current_group.shuffle[0]
      
      node = new_child_node(grid.dup.add!(token,next_move),min,max)
      extract_node_value(node,next_move)
      ( update_value(min,max) and break ) if value_at_limit?(min,max)
    end
    # if @move has not been set yet, it means that none of the attempted
    # moves was within the limits, meaning they were all equally bad. We
    # have to pick one anyway
    @move = next_move unless (@move)
  end
  
  def extract_node_value(node,next_move)
    if need_to_change_value?(node)
      @value = node.value
      @move = next_move
    end
  end
  
end

# this will be for the O move

class MinNode < TreeNode
  
  def initialize(grid, min=-1, max=1)
    super(grid,min,max)
  end
  
  def token
    O_TOKEN
  end
  
  def get_limit_value(min,max)
    max
  end
  
  def new_child_node(grid,min,max)
    MaxNode.new(grid,min,@value)
  end
  
  def need_to_change_value?(node)
    node.value < @value
  end
  
  def value_at_limit?(min,max)
    @value <= min
  end
  
  def update_value(min,max)
    @value = min
  end
  
end

# this will be for the X move

class MaxNode < TreeNode

  def initialize(grid, min=-1, max=1)
    super(grid,min,max)
  end
  
  def token
    X_TOKEN
  end
  
  def get_limit_value(min,max)
    min
  end
  
  def new_child_node(grid,min,max)
    MinNode.new(grid,@value,max)
  end
  
  def need_to_change_value?(node)
    node.value > @value
  end
  
  def value_at_limit?(min,max)
    @value >= max
  end
  
  def update_value(min,max)
    @value = max
  end
  
end