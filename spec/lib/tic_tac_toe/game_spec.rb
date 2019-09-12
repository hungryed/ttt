require "tic_tac_toe"

RSpec.describe TicTacToe::Game do
  let(:interactor) { TestInteractor.new(input_message: "X") }
  let(:player_1) { :player_1 }
  let(:player_2) { :player_2 }
  subject {
    described_class.new(
      interactor: interactor,
      player_1: player_1,
      player_2: player_2,
    )
  }

  describe "#run!" do
    let(:cycle_dub) { instance_double(described_class::PlayCycle) }

    before do
      allow(subject).to receive(:play_cycle).and_return(cycle_dub)
    end

    it "delegates to an instance" do
      expect(cycle_dub).to receive(:run!)
      subject.run!
    end
  end
end
