require "tic_tac_toe"

RSpec.describe TicTacToe::Session do
  let(:interactor) { TestInteractor.new(input_message: "X") }
  subject { described_class.new(interactor: interactor) }

  describe ".start!" do
    let(:dub) { instance_double(described_class) }

    it "delegates to an instance" do
      expect(described_class).to receive(:new).with(
        interactor: interactor,
        options: :here
      ).and_return(dub)
      expect(dub).to receive(:start!)
      described_class.start!(
        interactor: interactor,
        options: :here
      )
    end
  end

  describe "#start!" do
    let(:game_dub) { instance_double(TicTacToe::Game) }
    let(:player_dub) { instance_double(TicTacToe::Session::Player) }

    it "delegates gameplay forward to a game instance" do
      expect(TicTacToe::Session::Player).to receive(:new).with(
        type: :human,
        symbol: "X",
      ).and_return(player_dub)
      expect(TicTacToe::Session::Player).to receive(:new).with(
        type: :ai,
        symbol: "O",
      ).and_return(player_dub)
      expect(TicTacToe::Game).to receive(:new).with(
        interactor: interactor,
        player_1: player_dub,
        player_2: player_dub,
      ).and_return(game_dub)
      expect(game_dub).to receive(:run!)
      subject.start!
    end
  end
end
