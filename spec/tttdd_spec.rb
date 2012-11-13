require_relative "../lib/tttdd.rb"


describe "TTT" do
  
  context "displays the game" do
    
    before(:each) do
      @game = Game.new
      @board = INITIAL_BOARD.dup
    end
  
    it "shows an empty board to start" do
      @game.show.should == @board
    end
    
    it "changes the board based on a user move" do
      @game.move(X_TOKEN,"3")
      @game.show.should == @board.sub(/3/,X_TOKEN)
    end
    
  end
  
  context "recognizes states" do
    
    before(:each) do
      @game = Game.new
      @board = INITIAL_BOARD.dup
    end

    def adjust(range,token)
      range.each do |x|
        @game.move(token,x)
        @board.sub!(/#{x}/,token)
      end
    end
    
    it "recognizes a draw game" do
      adjust(["0","2","3","7"],X_TOKEN)
      adjust(["1","4","5","6","8"],O_TOKEN)
      @game.state.should == :draw
    end
    
    it "recognizes that a game is not a draw" do
      adjust(["0","2","3","7"],X_TOKEN)
      adjust(["1","4","5","6"],O_TOKEN)
      @game.state.should_not == :draw
    end
    
    it "recognizes a winning game" do
      pending("refactoring")
      adjust(["0","1","2"],X_TOKEN)
      @game.state.should == :x_win
    end
  end
  
  context "checks for bad moves" do
    
    before(:each) do
      @game = Game.new
      @board = INITIAL_BOARD.dup
    end
  
    it "throws a range error when move out of range" do
      ["Z","9","|","-"," "].each do |move|
        lambda { @game.move(X_TOKEN,move)}.should raise_error(RangeError)
      end
    end
    
    it "throws a runtime error if the move is already taken" do
      @game.move(X_TOKEN,"4")
      lambda { @game.move(X_TOKEN,"4") }.should raise_error(RuntimeError)
    end
  end
  
end
