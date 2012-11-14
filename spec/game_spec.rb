require_relative "../lib/game.rb"


describe "Game" do
  
  def adjust(range,token)
    range.each do |x|
      @game.move(token,x)
      @display.sub!(/#{x}/,token)
    end
  end
  
  context "displays the game correctly" do
    
    before(:each) do
      @game = Game.new
      @display = INITIAL_BOARD.dup
    end
  
    it "shows an empty board to start" do
      # nop
    end
    
    it "changes the board based on a user move" do
      adjust(["3"],X_TOKEN)
    end
    
    it "shows a full board" do
      adjust(["0","2","3","7"],X_TOKEN)
      adjust(["1","4","5","6","8"],O_TOKEN)
    end
    
    it "shows that board that is not full" do
      adjust(["0","2","3","7"],X_TOKEN)
      adjust(["1","4","5","6"],O_TOKEN)
    end
    
    after(:each) do
      @game.show.should == @display
    end
    
  end
  
  context "recognizes states" do
    
    before(:each) do
      @game = Game.new
      @display = INITIAL_BOARD.dup
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
      adjust(["0","1","2"],X_TOKEN)
      @game.state.should == :x_win
    end
    
    it "recognizes another winning game" do
      adjust(["2","4","6"],O_TOKEN)
      @game.state.should == :o_win
    end
    
    after(:each) do
      @game.show.should == @display
    end
    
  end
  
end
