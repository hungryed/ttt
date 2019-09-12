module TicTacToe
  class Game
    class PlayCycle
      attr_reader :interactor, :player_1, :player_2, :current_player

      def initialize(interactor:, player_1:, player_2:, **opts)
        @interactor = interactor
        @player_1 = player_1
        @player_2 = player_2
        @opts = opts
        @overall_turn_count = 0
      end

      def run!
        until board.game_finished?
          @current_player = ordered_players.find { |player| player != current_player }
          begin
            game_cycle(player: current_player)
            yield if block_given?
          rescue TicTacToe::BaseError => e
            raise e if test_mode?
            interactor.display_error(e)
            retry
          end
        end
        interactor.display_board(board: board)
        if board.winning_symbol
          interactor.display_message(message: "#{board.winning_symbol} has won!")
        else
          interactor.display_message(message: "Game draw!")
        end
      end

      private

      def board
        @board ||= Board.new
      end

      def ordered_players
        @ordered_players ||= [player_1, player_2]
      end

      def test_mode?
        ENV["TEST_MODE"] == "true"
      end

      def game_cycle(player:)
        answer = if player.human?
          human_turn(player: player)
        else
          ai_turn(player: player)
        end
        board.stage_and_verify_square(answer: answer, symbol: player.symbol)
        board.harden!(answer: answer, symbol: player.symbol)
        turn_count[player] += 1
        @overall_turn_count += 1
      end

      def turn_count
        @turn_count ||= Hash.new(0)
      end

      def human_turn(player:)
        interactor.display_board(board: board)
        get_space(player: player)
      end

      def ai_turn(player:)
        get_space(player: player)
      end

      def get_space(player:)
        other_player = ordered_players.find { |pla| pla != player }
        player.prompt_for_square(
          interactor: interactor,
          board: board,
          player_turn_index: turn_count[player],
          opposing_player_symbol: other_player&.symbol,
          overall_turn_index: @overall_turn_count
        )
      end
    end
  end
end
