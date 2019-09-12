require_relative "game/board"
require_relative "game/play_cycle"

module TicTacToe
  class Game
    attr_reader :interactor, :player_1, :player_2, :opts

    def initialize(interactor:, player_1:, player_2:, **opts)
      @interactor = interactor
      @player_1 = player_1
      @player_2 = player_2
      @opts = opts
    end

    def run!
      play_cycle.run!
    end

    private

    def play_cycle
      @play_cycle ||= PlayCycle.new(
        player_1: player_1,
        player_2: player_2,
        interactor: interactor,
        **opts
      )
    end
  end
end
