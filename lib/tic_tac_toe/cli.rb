require_relative "./cli/interactor"

module TicTacToe
  class Cli
    attr_reader :args

    class << self
      def run!(args)
        new(*args).run!
      end
    end

    def initialize(*args)
      @args = args
    end

    def run!
      TicTacToe.start_session!(interactor: interactor)
    end

    private

    def interactor
      @interactor ||= Interactor.new
    end
  end
end
