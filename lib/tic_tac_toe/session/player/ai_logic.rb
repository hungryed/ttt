module TicTacToe
  class Session
    class Player
      class AiLogic
        attr_reader :board, :player_symbol, :opposing_symbol

        def initialize(board:, player_symbol:, opposing_symbol:, **)
          @board = board
          @player_symbol = player_symbol
          @opposing_symbol = opposing_symbol
        end

        def weighted_move(options:, turn_index:, overall_turn_index:, array_method: :sample)
          # best first move is a corner
          if overall_turn_index == 0 && options.include?("A1")
            return "A1"
          end
          # best counter to any first move is center
          if turn_index == 0 && options.include?("B2")
            return "B2"
          end

          self_win = finishing_move_for(symbol: player_symbol, options: options)
          return self_win if self_win

          opposing_win = finishing_move_for(symbol: opposing_symbol, options: options)
          return opposing_win if opposing_win

          # if we other player can't win here and it's our second turn then we should opt for a possible win
          if turn_index == 1
            weighted_second_turn_opts = ["B1", "A2", "B3", "C2"]
            weighted_opt = weighted_second_turn_opts.find { |opt| options.include?(opt) }
            return weighted_opt if weighted_opt
          end

          winnable_combos = board.available_win_combos_for(symbol: player_symbol)
          if winnable_combos.any?
            move = (winnable_combos.send(array_method) & options)&.send(array_method)
            return move if move
          end
          options.send(array_method)
        end

        private

        def finishing_move_for(symbol:, options:)
          options.find.with_index do |opt|
            board.stage_and_verify_square(answer: opt, symbol: symbol) do |b|
              b.game_finished?
            end
          end
        end
      end
    end
  end
end
