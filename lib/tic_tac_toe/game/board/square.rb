module TicTacToe
  class Game
    class Board
      class Square
        attr_accessor :symbol

        attr_reader :row, :col
        def initialize(row:, col:)
          @row = row
          @col = col
        end

        def locator
          "#{col}#{row}"
        end

        def available?
          !symbol
        end
      end
    end
  end
end
