require "tic_tac_toe"

RSpec.describe TicTacToe::Session::Player do
  let(:interactor) { TestInteractor.new(input_message: "A1") }
  let(:player_type) { :human }
  subject { described_class.new(type: player_type, symbol: "X") }

  describe "#human?" do
    it "should be truthy" do
      expect(subject.human?).to be true
    end

    context "as an ai" do
      let(:player_type) { :ai }

      it "should be falsey" do
        expect(subject.human?).to be false
      end
    end
  end

  describe "prompt_for_square" do
    let(:board) { TicTacToe::Game::Board.new }

    it "prompts the player for what square they want" do
      expect(
        subject.prompt_for_square(
          interactor: interactor,
          board: board,
          opposing_player_symbol: "O",
          player_turn_index: 0,
          overall_turn_index: 0,
        )
      ).to eq "A1"
    end

    context "ai player" do
      let(:player_type) { :ai }
      let(:logic_dub) { instance_double(described_class::AiLogic) }

      it "delegates the a logic handler" do
        expect(described_class::AiLogic).to receive(:new).with(
          board: board,
          player_symbol: "X",
          opposing_symbol: "O",
        ).and_return(logic_dub)
        expect(logic_dub).to receive(:weighted_move).with(
          options: ["A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"],
          turn_index: 0,
          overall_turn_index: 0,
        ).and_return("A1")
        subject.prompt_for_square(
          interactor: interactor,
          board: board,
          opposing_player_symbol: "O",
          player_turn_index: 0,
          overall_turn_index: 0,
        )
      end
    end
  end
end
