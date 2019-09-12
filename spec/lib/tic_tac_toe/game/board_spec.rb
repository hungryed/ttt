require "tic_tac_toe"

RSpec.describe TicTacToe::Game::Board do
  let(:win_order) {
    [
      "A1",
      "B2",
      "A2",
      "B1",
      "A3"
    ]
  }
  let(:draw_order) {
    [
      "A1",
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
  let(:turn_order) { [] }
  subject { described_class.new }

  before do
    turn_order.each_with_index do |move, index|
      subject.harden!(answer: move, symbol: index.even? ? "X" : "O")
    end
  end

  describe "#valid_options" do
    it "returns a list of locators for available squares" do
      expect(subject.valid_options).to eq([
        "A1", "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"
      ])
    end

    context "with a move made" do
      let(:turn_order) { ["A1"] }

      it "returns a list of locators for available squares" do
        expect(subject.valid_options).to eq([
          "A2", "A3", "B1", "B2", "B3", "C1", "C2", "C3"
        ])
      end
    end
  end

  describe "#game_finished?" do
    it "discerns if the game is finished" do
      expect(subject.game_finished?).to be false
    end

    context "complete games" do
      let(:turn_order) { win_order }

      it "returns a truthy value" do
        expect(subject.game_finished?).to be true
      end

      context "draw" do
        let(:turn_order) { draw_order }

        it "returns a truthy value" do
          expect(subject.game_finished?).to be true
        end
      end
    end
  end

  describe "#winning_symbol" do
    it "returns nothing if there is no winning symbol" do
      expect(subject.winning_symbol).to be nil
    end

    context "complete games" do
      let(:turn_order) { win_order }

      it "returns a the winner with 3 in a row" do
        expect(subject.winning_symbol).to eq "X"
      end

      context "draw" do
        let(:turn_order) { draw_order }

        it "returns no winner" do
          expect(subject.winning_symbol).to be nil
        end
      end
    end
  end

  describe "#available_win_combos_for" do
    it "returns a list of all possible win permutations" do
      expect(subject.available_win_combos_for(symbol: "X")).to eq(
        [
          ["A1", "A2", "A3"],
          ["A1", "B1", "C1"],
          ["A1", "B2", "C3"],
          ["A2", "B2", "C2"],
          ["A3", "B2", "C1"],
          ["A3", "B3", "C3"],
          ["B1", "B2", "B3"],
          ["C1", "C2", "C3"]
        ]
      )
    end

    context "complete games" do
      let(:turn_order) { win_order }

      it "returns a list that includes the winning row" do
        expect(subject.available_win_combos_for(symbol: "X")).to include(
          ["A1", "A2", "A3"]
        )
      end
    end
  end

  describe "#stage_and_verify_square" do
    it "returns a list of locators for available squares" do
      expect(subject.stage_and_verify_square(answer: "A1", symbol: "O")).to be nil
    end

    it "raises an error for invalid moves" do
      expect { subject.stage_and_verify_square(answer: "A5", symbol: "O") }.to raise_error(
        TicTacToe::InvalidLocation, "No square match for A5"
      )
    end

    it "returns the square to the original state" do
      subject.stage_and_verify_square(answer: "A1", symbol: "O") do
        expect(subject.send(:square_for, "A1").symbol).to eq "O"
      end
      expect(subject.send(:square_for, "A1").symbol).to eq nil
    end

    context "with a move made" do
      let(:turn_order) { ["A1"] }

      it "returns a list of locators for available squares" do
        expect { subject.stage_and_verify_square(answer: "A1", symbol: "O") }.to raise_error(
          TicTacToe::InvalidLocation, "Square A1 is taken"
        )
      end
    end
  end

  describe "#harden!" do
    it "returns a list of locators for available squares" do
      expect(subject.harden!(answer: "A1", symbol: "O")).to eq "O"
    end

    it "raises an error for invalid moves" do
      expect { subject.harden!(answer: "A5", symbol: "O") }.to raise_error(
        TicTacToe::InvalidLocation, "No square match for A5"
      )
    end

    it "sets the square to the provided symbol" do
      subject.harden!(answer: "A1", symbol: "O")
      expect(subject.send(:square_for, "A1").symbol).to eq "O"
    end

    context "with a move made" do
      let(:turn_order) { ["A1"] }

      it "returns a list of locators for available squares" do
        expect { subject.harden!(answer: "A1", symbol: "O") }.to raise_error(
          TicTacToe::InvalidLocation, "Square A1 is taken"
        )
      end
    end
  end
end
