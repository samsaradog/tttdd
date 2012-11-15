require_relative "tree"

class Brain
    
  def x_move(grid)
    raise RuntimeError if grid.grid_full?
    
    node = MaxNode.new(grid)
    node.move
  end
  
  def o_move(grid)
    raise RuntimeError if grid.grid_full?
    
    node = MinNode.new(grid)
    node.move
  end
end
