require "tic_tac_toe"

RSpec.describe TicTacToe::Game::PlayCycle do
  let(:win_order) {
    [
      "B2",
      "A2",
      "B1",
      "A3"
    ]
  }
  let(:draw_order) {
    [
      "B2",
      "C3",
      "B1",
      "B3",
      "A3",
      "A2",
      "C2",
      "C1",
    ]
  }
  let(:interactor) { TestInteractor.new(input_message: "A1") }
  let(:player_1) {
    TicTacToe::Session::Player.new(
      type: :human,
      symbol: "X",
    )
  }
  let(:player_2) {
    TicTacToe::Session::Player.new(
      type: :human,
      symbol: "O"
    )
  }
  subject {
    described_class.new(
      interactor: interactor,
      player_1: player_1,
      player_2: player_2,
    )
  }

  describe "#run!" do
    before do
      i = 0
      subject.run! do
        interactor.reset_input_message_to(turn_order[i])
        i += 1
      end
      interactor.output.rewind
    end

    context "with winner" do
      let(:turn_order) { win_order }

      it "ends with the correct board" do
        expect(interactor.output.read).to include(<<-STR.chomp
     +---+---+---+
1    | X | O |   |
     +---+---+---+
2    | X | O |   |
     +---+---+---+
3    | X |   |   |
     +---+---+---+
STR
        )
      end

      it "displays a winner" do
        expect(interactor.output.read).to include("X has won!")
      end
    end

    context "with draw" do
      let(:turn_order) { draw_order }

      it "ends with the correct board" do
        expect(interactor.output.read).to include(<<-STR.chomp
     +---+---+---+
1    | X | O | X |
     +---+---+---+
2    | X | O | O |
     +---+---+---+
3    | O | X | X |
     +---+---+---+
STR
        )
      end

      it "displays a winner" do
        expect(interactor.output.read).to include("Game draw!")
      end
    end
  end
end
