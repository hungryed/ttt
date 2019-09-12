require_relative "player/ai_logic"

module TicTacToe
  class Session
    class Player
      attr_reader :type, :symbol, :opts

      def initialize(type:, symbol:, **opts)
        @type = type
        @symbol = symbol
        @opts = opts
      end

      def human?
        type.to_sym == :human
      end

      def prompt_for_square(interactor:, board:, opposing_player_symbol:, player_turn_index:, overall_turn_index:)
        if human?
          interactor.prompt_for(
            message: "Where do you want to move?",
            valid_options: board.valid_options,
          )
        else
          AiLogic.new(
            board: board,
            player_symbol: symbol,
            opposing_symbol: opposing_player_symbol,
            **opts
          ).weighted_move(
            options: board.valid_options,
            turn_index: player_turn_index,
            overall_turn_index: overall_turn_index
          )
        end
      end
    end
  end
end
