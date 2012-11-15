require_relative "../lib/game"


describe "Game" do
  
  def adjust(range,token)
    range.each do |x|
      @game.move(token,x)
      @display.sub!(/#{x}/,token)
    end
  end
  
  before(:each) do
    @game = Game.new
    @display = INITIAL_BOARD.dup
  end
  
  context "displays the game correctly" do
  
    it "shows an empty board to start" do
      # covered in the after(:each) below
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
      @game.board.should == @display
    end
    
  end
  
  context "recognizes states" do

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
      @game.board.should == @display
    end
    
  end
  
  context "initializes game correctly" do
    
    it "initializes correctly when human goes first" do
      @game.stub(:human_first?).and_return(true)
      @game.should_receive(:output).once
      @game.initialize_game
    end
    
    it "initializes correctly when computer goes first" do
      @game.stub(:human_first?).and_return(false)
      @game.should_receive(:output).once
      @game.should_receive(:generate_x_move).once
      @game.should_receive(:move).once
      @game.initialize_game
    end
  end
  
  context "validates user input" do
    
    it "returns true for correct input" do
      @game.stub(:state).and_return(:open)
      inputs = ["y","Y","Q","q","X","x"]
      inputs += ("0".."8").to_a
      inputs.each { |x| @game.validate_input(x).should == true }
      
    end
    
    it "returns false for bad input" do
      @game.stub(:state).and_return(:draw)
      inputs = ["ab","9","8"]
      inputs.each { |x| @game.validate_input(x).should == nil }
    end
  end
  
  context "routes user input correctly" do
    
    it "calls initialize when asked for a new game" do
      @game.stub(:validate_input).and_return(true)
      @game.should_receive(:initialize_game)
      @game.add_response("y").should == true
    end
    
    it "calls output and returns false when asked to quit" do
      @game.stub(:validate_input).and_return(true)
      @game.should_receive(:output)
      @game.add_response("n").should == false
    end
    
    it "calls move when it receives a legitimate move" do
      user_move = "0"
      @game.stub(:validate_input).and_return(true)
      @game.stub(:state).and_return(:draw)
      @game.should_receive(:move).with(O_TOKEN,user_move)
      @game.add_response(user_move).should == true
    end
    
    it "fails gracefully when it gets a bad move" do
      user_move = "0"
      @game.stub(:validate_input).and_return(true)
      @game.add_response(user_move).should == true
      @game.should_receive(:output).with(user_move+MOVE_TAKEN_MESSAGE)
      @game.add_response(user_move).should == true
    end
    
    it "makes a computer move after a user move when available" do
      user_move = "0"
      computer_move = "2"
      @game.stub(:validate_input).and_return(true)
      @game.stub(:state).and_return(:open)
      @game.stub(:generate_x_move).and_return(computer_move)
      
      @game.should_receive(:move).with(O_TOKEN,user_move)
      @game.should_receive(:move).with(X_TOKEN,computer_move)
      @game.add_response(user_move).should == true
    end
  end
  
  context "displays the right information" do
    
    it "prompts for another move when game not finished" do
      @game.stub(:state).and_return(:open)
      @game.prompt.should == MOVE_MESSAGE
    end
    
    it "prompts for another game when game is finished" do
      @game.stub(:state).and_return(:draw)
      @game.prompt.should == GAME_COMPLETED_MESSAGE
    end
    
    it "notifies a draw game correctly" do
      @game.stub(:state).and_return(:draw)
      @game.notification.should == DRAW_GAME_MESSAGE
    end
    
    it "notifies an X win game correctly" do
      @game.stub(:state).and_return(:x_win)
      @game.notification.should == X_WINS_MESSAGE
    end
    
    it "notifies a O win game correctly" do
      @game.stub(:state).and_return(:o_win)
      @game.notification.should == O_WINS_MESSAGE
    end
    
    it "notifies for bad input" do
      bad_input = "xyz"
      @game.should_receive(:output).with(BAD_INPUT_MESSAGE+bad_input+"\n")
      @game.add_response(bad_input)
    end
  end
  
end
