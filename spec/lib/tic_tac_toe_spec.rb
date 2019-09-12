require "tic_tac_toe"

RSpec.describe TicTacToe do
  describe ".start_session!" do
    it "starts a game with the provided display option" do
      expect(described_class::Session).to receive(:start!).with(
        interactor: "interaction_tool",
        opt: :here
      )
      described_class.start_session!(
        interactor: "interaction_tool",
        opt: :here
      )
    end
  end
end
