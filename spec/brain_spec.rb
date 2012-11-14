require_relative "../lib/brain.rb"

describe "Brain" do
  before(:each) do
    @brain = Brain.new
    @grid  = Grid.new
  end
  
  it "blocks a potential winner" do
    [0,1].each { |x| @grid.add(O_TOKEN,x) }
    @brain.best_move(@grid).should == 2
  end
  
  it "blocks another potential winner" do
    [0,4].each { |x| @grid.add(O_TOKEN,x) }
    @brain.best_move(@grid).should == 8
  end
    
end