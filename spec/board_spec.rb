require_relative "../lib/board.rb"

describe "Board" do
  before(:each) do
    @board = Board.new
  end
  
  context "recognizing game state" do
    
    it "recognizes a draw game" do
      ["0","2","3","7"].each { |x| @board.add(X_TOKEN,x)}
      ["1","4","5","6","8"].each { |x| @board.add(O_TOKEN,x)}
      @board.state.should == :draw
    end
    
    it "recognizes a game is not a draw" do
      ["0","2","3","7"].each { |x| @board.add(X_TOKEN,x)}
      ["1","4","5","6"].each { |x| @board.add(O_TOKEN,x)}
      @board.state.should_not == :draw
    end
  end
  
  context "checks for bad moves" do
    
    it "throws a range error when move out of range" do
      ["Z","9","|","-"," "].each do |move|
        lambda { @board.add(X_TOKEN,move)}.should raise_error(RangeError)
      end
    end
    
    it "throws a runtime error if the move is already taken" do
      @board.add(X_TOKEN,"4")
      lambda { @board.add(X_TOKEN,"4") }.should raise_error(RuntimeError)
    end
  end
  
end
