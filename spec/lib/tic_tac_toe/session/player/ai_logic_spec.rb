require "tic_tac_toe"

RSpec.describe TicTacToe::Session::Player::AiLogic do
  let(:board) { TicTacToe::Game::Board.new }
  let(:almost_win_order) {
    [
      "A1",
      "B2",
      "A2",
      "B1",
    ]
  }
  let(:almost_draw_order) {
    [
      "A1",
      "B2",
      "C3",
      "B1",
      "B3",
      "A3",
      "A2",
    ]
  }
  let(:turn_order) { [] }
  let(:player_symbol) { "X" }
  let(:opposing_symbol) { "O" }
  subject {
    described_class.new(
      board: board,
      player_symbol: player_symbol,
      opposing_symbol: opposing_symbol,
    )
  }

  before do
    turn_order.each_with_index do |move, index|
      board.harden!(answer: move, symbol: index.even? ? "X" : "O")
    end
  end

  describe "weighted_move" do
    context "overall first move" do
      it "returns a corner square" do
        expect(
          subject.weighted_move(
            options: board.valid_options,
            turn_index: 0,
            overall_turn_index: 0
          )
        ).to eq "A1"
      end
    end

    context "first player move" do
      it "returns the center square" do
        expect(
          subject.weighted_move(
            options: board.valid_options,
            turn_index: 0,
            overall_turn_index: 1
          )
        ).to eq "B2"
      end
    end

    context "second player move" do
      it "returns a square neighboring the center" do
        expect(
          subject.weighted_move(
            options: board.valid_options,
            turn_index: 1,
            overall_turn_index: 2
          )
        ).to eq "B1"
      end

      context "taken square" do
        let(:turn_order) { ["A1", "B1"] }

        it "returns a different square neighboring the first move" do
          expect(
            subject.weighted_move(
              options: board.valid_options,
              turn_index: 1,
              overall_turn_index: 2
            )
          ).to eq "A2"
        end
      end
    end

    context "winnable move" do
      let(:turn_order) { almost_win_order }

      it "returns the move that will allow the computer to win" do
        expect(
          subject.weighted_move(
            options: board.valid_options,
            turn_index: 1,
            overall_turn_index: 2
          )
        ).to eq "A3"
      end

      context "opposing player staged to win" do
        let(:player_symbol) { "O" }
        let(:opposing_symbol) { "X" }

        it "returns the move that will allow the computer to win" do
          expect(
            subject.weighted_move(
              options: board.valid_options,
              turn_index: 1,
              overall_turn_index: 2
            )
          ).to eq "B3"
        end
      end
    end

    context "draw move" do
      let(:turn_order) { almost_draw_order }

      it "returns the move that will allow the computer to win" do
        expect(
          subject.weighted_move(
            options: board.valid_options,
            turn_index: 1,
            overall_turn_index: 2,
            array_method: :first
          )
        ).to eq "C1"
      end
    end
  end
end
