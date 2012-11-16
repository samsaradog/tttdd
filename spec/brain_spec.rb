require_relative "../lib/brain"

describe "Brain" do
  before(:each) do
    @grid  = Grid.new
  end

  context "error checking" do
    it "throws an error if no move found for x or o" do
      (0..8).each { |x| @grid.add!(X_TOKEN,x) }
      lambda { Brain.x_move(@grid) }.should raise_error(RuntimeError)
      lambda { Brain.o_move(@grid) }.should raise_error(RuntimeError)
    end
  end
  
  context "blocking winners" do
    
    it "blocks a potential O winner" do
      [0,1].each { |x| @grid.add!(O_TOKEN,x) }
      [8].each { |x| @grid.add!(X_TOKEN,x) }
      Brain.x_move(@grid).should == 2
    end

    it "blocks another potential O winner" do
      [0,4].each { |x| @grid.add!(O_TOKEN,x) }
      [1].each { |x| @grid.add!(X_TOKEN,x) }
      Brain.x_move(@grid).should == 8
    end
    
    it "blocks a potential X winner" do
      [8].each { |x| @grid.add!(O_TOKEN,x) }
      [0,1].each { |x| @grid.add!(X_TOKEN,x) }
      Brain.o_move(@grid).should == 2
    end
  end
  
  context "finding winners" do
    
    it "makes a winning move for x" do
      [0,3,5].each { |x| @grid.add!(O_TOKEN,x) }
      [4,6,7,8].each { |x| @grid.add!(X_TOKEN,x) }
      Brain.x_move(@grid).should == 2
    end
    
    it "makes a winning move for o" do
      [4,6,7,8].each { |x| @grid.add!(O_TOKEN,x) }
      [0,3,5].each { |x| @grid.add!(X_TOKEN,x) }
      Brain.o_move(@grid).should == 2
    end
  end
  
  context "preventing winners" do
    
    it "makes an edge move when corners are filled" do
      # pending("Tree implementation")
      [0,4].each { |move| @grid.add!(X_TOKEN,move) }
      [8].each   { |move| @grid.add!(O_TOKEN,move) }
      (Brain.o_move(@grid) % 2).should == 1
    end
  end
    
end