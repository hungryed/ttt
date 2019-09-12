require "tic_tac_toe"

RSpec.describe TicTacToe::Cli::Interactor do
  subject { described_class.new }
  let(:output) { StringIO.new }
  let(:input_message) { "any input" }
  let(:input) { StringIO.new(input_message) }

  before do
    allow(subject).to receive(:output).and_return(output)
    allow(subject).to receive(:input).and_return(input)
  end

  describe "prompt_for" do
    it "gets a response from the user and upcases" do
      expect(subject.prompt_for(message: "any message", valid_options: ["any input"])).to eq "ANY INPUT"
    end

    it "raises an error if the is no match" do
      expect { subject.prompt_for(message: "any message", valid_options: ["other input"]) }.to raise_error(
        TicTacToe::InvalidAnswer, "Answer was invalid. Please answer with any of other input"
      )
    end
  end

  describe "display_error" do
    it "displays the error message" do
      begin
        raise "banana"
      rescue => e
        @error = e
      end
      subject.display_error(@error)
      output.rewind
      expect(output.read).to include("banana")
    end
  end

  describe "display message" do
    it "displays the provided message" do
      subject.display_message(message: "hello world")
      output.rewind
      expect(output.read).to include("hello world")
    end
  end

  describe "display_board" do
    let(:board) { TicTacToe::Game::Board.new }

    it "displays the board" do
      subject.display_board(board: board)
      output.rewind
      expect(output.read).to include(<<-STR.chomp
     +---+---+---+
1    |   |   |   |
     +---+---+---+
2    |   |   |   |
     +---+---+---+
3    |   |   |   |
     +---+---+---+
STR
    )
    end

    it "displays the header" do
      subject.display_board(board: board)
      output.rewind
      expect(output.read).to include("       A   B   C")
    end
  end
end
