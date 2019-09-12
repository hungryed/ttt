require_relative "board/square"

module TicTacToe
  class Game
    class Board
      COLUMN_NAMES = ["A", "B", "C"]
      WIN_STATES = {
        "A2" => [["A1", "A3"]],
        "B1" => [["A1", "C1"]],
        "B2" => [["A2", "C2"], ["A1", "C3"], ["A3", "C1"], ["B1", "B3"]],
        "B3" => [["A3", "C3"]],
        "C2" => [["C1", "C3"]],
      }
      def valid_options
        available_squares.map(&:locator).sort
      end

      def game_finished?
        return true if available_squares.empty?
        !!winning_run
      end

      def winning_symbol
        run = winning_run
        return unless run
        square_for(run.first)&.symbol
      end

      def definition
        @definition ||= [1,2,3].map do |row|
          COLUMN_NAMES.map do |col|
            Square.new(
              col: col,
              row: row
            )
          end
        end
      end

      def available_win_combos_for(symbol:)
        WIN_STATES.each_with_object([]) do |(start_loc, win_conditions), memo|
          start_square = square_for(start_loc)
          win_conditions.each do |combo|
            combo_match = combo.all? do |locator|
              square = square_for(locator)
              !square.symbol || (square.symbol == symbol)
            end

            if combo_match
              memo << [start_loc, *combo].sort
            end
          end
        end.sort
      end

      def stage_and_verify_square(answer:, symbol:)
        square = find_and_validate_square(locator: answer)
        old_symbol = square.symbol
        square.symbol = symbol
        res = yield(self) if block_given?
        square.symbol = old_symbol
        res
      end

      def harden!(answer:, symbol:)
        square = find_and_validate_square(locator: answer)
        square.symbol = symbol
      end

      private

      def available_squares
        flat_squares.select(&:available?)
      end

      def flat_squares
        definition.flatten
      end

      def winning_run
        run = nil
        WIN_STATES.each do |start_loc, win_conditions|
          break if run
          start_square = square_for(start_loc)
          win_conditions.each do |combo|
            combo_match = combo.all? do |locator|
              square = square_for(locator)
              square.symbol && square.symbol == start_square.symbol
            end

            if combo_match
              run = [start_loc, *combo]
            end
          end
        end
        run
      end

      def find_and_validate_square(locator:)
        square = square_for(locator)
        unless square
          raise InvalidLocation.new("No square match for #{locator}")
        end
        if square.symbol
          raise InvalidLocation.new("Square #{locator} is taken")
        end
        square
      end

      def square_for(locator)
        flat_squares.find { |square| square.locator == locator }
      end
    end
  end
end
