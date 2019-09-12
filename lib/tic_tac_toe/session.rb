require_relative "session/player"

module TicTacToe
  class Session
    DEFAULT_PLAY_SYMBOLS = ["X", "O"]
    attr_reader :interactor, :opts

    class << self
      def start!(**opts)
        new(**opts).start!
      end
    end

    def initialize(interactor:, **opts)
      @interactor = interactor
      @opts = opts
    end

    def start!
      game.run!
    end

    private

    def player_1_symbol
      @player_1_symbol ||= interactor.prompt_for(
        message: "Which player do you want to be? X or O",
        valid_options: DEFAULT_PLAY_SYMBOLS
      )
    end

    def game
      @game ||= Game.new(
        interactor: interactor,
        player_1: player_1,
        player_2: player_2,
        **opts
      )
    end

    def player_1
      @player_1 ||= Player.new(
        type: :human,
        symbol: player_1_symbol,
        **opts
      )
    end

    def player_2
      @player_2 ||= Player.new(
        type: :ai,
        symbol: DEFAULT_PLAY_SYMBOLS.find { |sym| sym != player_1_symbol },
        **opts
      )
    end
  end
end
