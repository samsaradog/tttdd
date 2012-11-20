require_relative "grid"

STATE_TO_VALUE = { :o_win => -1, :x_win => 1, :draw => 0, :open => 0 }

class TreeNode
  attr_reader :value, :move, :min, :max, :root
  
  def initialize(root,min,max)
    @root, @min, @max = root, min, max
    @value = STATE_TO_VALUE[root.state]
    minimax() if (:open == root.state)
  end
  
  def minimax()
    available_moves = root.group_moves(token)
    
    @value = get_limit_value
    next_move = nil 
    
    available_moves.each do | current_group |
      next_move = current_group.shuffle[0]
      node = new_child_node(root.dup.add!(token,next_move),min,max)
      ( @value = node.value and @move = next_move ) if need_to_change_value?(node)
      ( (@value = pruning_value) and break ) if value_at_limit?
    end
    
    @move = next_move unless (@move)
  end
  
end

class MinNode < TreeNode
  
  def initialize(root, min=-1, max=1)
    super(root,min,max)
  end
  
  def get_limit_value
    max
  end
  
  def need_to_change_value?(node)
    node.value < value
  end
  
  def new_child_node(node,min,max)
    MaxNode.new(node,min,value)
  end
  
  def pruning_value
    min
  end
  
  def token
    O_TOKEN
  end
  
  def value_at_limit?
    value <= min
  end
  
end

class MaxNode < TreeNode

  def initialize(root, min=-1, max=1)
    super(root,min,max)
  end
  
  def get_limit_value
    min
  end
  
  def need_to_change_value?(node)
    node.value > value
  end
  
  def new_child_node(node,min,max)
    MinNode.new(node,value,max)
  end
  
  def pruning_value
    max
  end
  
  def token
    X_TOKEN
  end
  
  def value_at_limit?
    value >= max
  end
  
end