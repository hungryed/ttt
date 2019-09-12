require "tic_tac_toe"

RSpec.describe TicTacToe::Game::Board::Square do
  let(:col) { "A" }
  let(:row) {1 }
  subject { described_class.new(row: row, col: col) }

  describe "#locator" do
    it "returns a locator string to find the square with" do
      expect(subject.locator).to eq "A1"
    end
  end

  describe "#available?" do
    it "has a truthy value if there is no symbol present on the square" do
      expect(subject.available?).to be true
    end

    it "has a falsey value if there is a symbol present" do
      subject.symbol = "banana"
      expect(subject.available?).to be false
    end
  end
end
