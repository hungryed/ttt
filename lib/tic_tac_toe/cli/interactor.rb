module TicTacToe
  class Cli
    class Interactor
      ROW_SEPARATOR = "     +---+---+---+"

      def prompt_for(message:, valid_options:)
        display_message(message: message)
        answer = ask.upcase
        validate_answer!(answer: answer, valid_options: valid_options)
        answer
      rescue => e
        raise e if test_mode?
        display_error(e)
        retry
      end

      def display_message(message:)
        display_output(message)
      end

      def display_board(board:)
        column_header = "       "
        column_header = Game::Board::COLUMN_NAMES.each_with_object(column_header) do |col, memo|
          memo << "#{col}   "
        end

        row_contents = board.definition.each_with_object([]).with_index do |(row, content), row_num|
          content << ROW_SEPARATOR
          row_str = row.each_with_object([]).with_index do |(square, memo), index|
            if index == 0
              memo << "#{row_num + 1}   "
            end
            sym = square.symbol || " "
            memo << sym
          end.join(" | ")
          row_str << " |"
          content << row_str
        end
        row_contents << ROW_SEPARATOR

        display_message(message: column_header)
        display_message(message: "\n")
        display_message(message: row_contents.join("\n"))
      end

      def display_error(error)
        display_message(message: error.message)
      end

      private

      def test_mode?
        ENV["TEST_MODE"] == "true"
      end

      def input
        @input ||= $stdin
      end

      def output
        @output ||= $stdout
      end

      def display_output(message)
        output.puts message
      end

      def ask
        input.gets&.chomp
      end

      def validate_answer!(answer:, valid_options:)
        unless valid_options.map(&:upcase).include?(answer)
          raise InvalidAnswer.new("Answer was invalid. Please answer with any of #{valid_options.join(", ")}")
        end
      end
    end
  end
end
