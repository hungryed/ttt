require "tic_tac_toe"

RSpec.describe TicTacToe::Cli do
  let(:args) { [] }
  subject { described_class.new(*args) }
  describe ".run!" do
    let(:dub) { instance_double(described_class) }

    it "delegates to an instance" do
      expect(described_class). to receive(:new).and_return(dub)
      expect(dub).to receive(:run!)
      described_class.run!(args)
    end
  end

  describe "#run!" do
    let(:interactor_dub) { instance_double(described_class::Interactor) }

    before :each do
      allow(described_class::Interactor).to receive(:new).and_return(interactor_dub)
    end

    it "delegates gameplay forward" do
      expect(TicTacToe).to receive(:start_session!).with(interactor: interactor_dub)
      subject.run!
    end
  end
end
