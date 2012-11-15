require_relative "../lib/tree"

X_DRAW_MOVES = [1,2,4,5,7]
O_DRAW_MOVES = [0,3,6,8]

describe "Tree" do
  before(:each) do
    @grid = Grid.new
  end
  
  context "draw game" do
    before(:each) do
      X_DRAW_MOVES.each { | move | @grid.add(X_TOKEN,move) }
      O_DRAW_MOVES.each { | move | @grid.add(O_TOKEN,move) }
    end
    
    it "min should have value 0" do
      node = MinNode.new(@grid)
      node.value.should == 0
    end
    
    it "max should have value 0" do
      node = MaxNode.new(@grid)
      node.value.should == 0
    end
  end
  
  context "O winning min node" do
    before(:each) do
      (0..2).each { | move | @grid.add(O_TOKEN,move)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value -1" do
      @node.value.should == -1
    end
    
    it "should have an empty move" do
      @node.move.should be_false
    end
  end
  
  context "X winning max node" do
    before(:each) do
      (0..2).each { | move | @grid.add(X_TOKEN,move)}
      @node = MaxNode.new(@grid)
    end
    
    it "should have the value 1" do
      @node.value.should == 1
    end
    
    it "should have an empty move" do
      @node.move.should be_false
    end
  end
  
  context "X win depth 1" do
    #  X | O | X
    # ----------
    #  X | O | O
    # ----------
    #    | X | O
    
    before(:each) do
      [0,2,5,7].each { | move | @grid.add(X_TOKEN,move)}
      [1,3,4,8].each { | move | @grid.add(O_TOKEN,move)}
      @node = MaxNode.new(@grid)
    end
    
    it "should have the value 1" do
      @node.value.should == 1
    end
    
    it "should have the move 6" do
      @node.move.should == 6
    end
     
  end
  
  context "O win depth 1" do
    #  O | X | O
    # ----------
    #  O | X | X
    # ----------
    #    | O | X
    
    before(:each) do
      [0,2,5,7].each { | pos | @grid.add(O_TOKEN,pos)}
      [1,3,4,8].each { | pos | @grid.add(X_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value -1" do
      @node.value.should == -1
    end
    
    it "should have the move 6" do
      @node.move.should == 6
    end
     
  end
  
  context "X lose depth 2" do
    #    | X |  
    # ----------
    #  O | O | X
    # ----------
    # O | X | O
    
    before(:each) do
      [4,6,7,8].each { | pos | @grid.add(O_TOKEN,pos)}
      [1,3,5].each   { | pos | @grid.add(X_TOKEN,pos)}
      @node = MaxNode.new(@grid)
    end
    
    it "should have the value -1" do
      @node.value.should == -1
    end
    
    it "should have the move 0 or 2" do
      result = (@node.move == 0 or @node.move == 2)
      result.should be_true
    end
    
  end
  
  context "O lose depth 2" do
    #    | O |  
    # ----------
    #  X | X | O
    # ----------
    # X | O | X
    
    before(:each) do
      [1,3,5].each   { | pos | @grid.add(O_TOKEN,pos)}
      [4,6,7,8].each { | pos | @grid.add(X_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 1" do
      @node.value.should == 1
    end
    
    it "should have the move 0 or 2" do
      result = (@node.move == 0 or @node.move == 2)
      result.should be_true
    end
    
  end
  
  context "O draw depth 2" do
    #  O | O | X
    # ----------
    #  X | X |  
    # ----------
    # O | X |  
    
    before(:each) do
      [2,5,7,8].each { | pos | @grid.add(X_TOKEN,pos)}
      [0,1,6].each   { | pos | @grid.add(O_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
    it "should have the move 3" do
      @node.move.should == 3
    end
    
  end
  
  context "O draw depth 3" do
    #    |   |  
    # ----------
    #  X | X | O
    # ----------
    # O | O | X
    
    before(:each) do
      [4,7,8].each { | pos | @grid.add(X_TOKEN,pos)}
      [3,5,6].each { | pos | @grid.add(O_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
    it "should have the move 0" do
      @node.move.should == 0
    end
    
  end

  context "O draw depth 6" do
    #    |   |  
    # ----------
    #  X | X |  
    # ----------
    # O |   |  
    
    before(:each) do
      [7,8].each { | pos | @grid.add(X_TOKEN,pos)}
      [6].each   { | pos | @grid.add(O_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
    it "should have the move 3" do
      @node.move.should == 3
    end
    
  end
  
  context "O win depth 5" do
    #    | X |  
    # ----------
    #    | O | O
    # ----------
    #   |   | X
    
    before(:each) do
      [1,4].each { | pos | @grid.add(X_TOKEN,pos)}
      [3,8].each { | pos | @grid.add(O_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value -1" do
      @node.value.should == -1
    end
    
    # The algorighm is about winning, but not winning quickly, so the 
    # computer could pick one of several moves that will lead to an
    # eventual win
    
  end
  
  context "O draw depth 6" do
    #  O | X |  
    # ----------
    #    | X |  
    # ----------
    #   |   |  
    
    before(:each) do
      [1,8].each { | pos | @grid.add(X_TOKEN,pos)}
      [0].each   { | pos | @grid.add(O_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
    it "should have the move 5" do
      @node.move.should == 5
    end
    
  end
  
  context "O draw depth 7" do
    #    | O |  
    # ----------
    #    | X |  
    # ----------
    #   |   |  
    
    before(:each) do
      [8].each { | pos | @grid.add(X_TOKEN,pos)}
      [1].each { | pos | @grid.add(O_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
  end
  
  context "O win depth 7" do
    #    | X |  
    # ----------
    #    | O |  
    # ----------
    #   |   |  
    
    before(:each) do
      [8].each { | pos | @grid.add(O_TOKEN,pos)}
      [1].each { | pos | @grid.add(X_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value -1" do
      @node.value.should == -1
    end
    
  end
  
  context "O draw depth 8" do
    #    |   |  
    # ----------
    #    | X |  
    # ----------
    #   |   |  
    
    before(:each) do
      [8].each { | pos | @grid.add(X_TOKEN,pos)}
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
  end
  
  context "O draw depth 9" do
    #    |   |  
    # ----------
    #    |   |  
    # ----------
    #   |   |  
    
    before(:each) do
      @node = MinNode.new(@grid)
    end
    
    it "should have the value 0" do
      @node.value.should == 0
    end
    
  end
end

