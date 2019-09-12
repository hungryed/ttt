require "tic_tac_toe"

class TestInteractor < TicTacToe::Cli::Interactor
  attr_accessor :input_message

  def initialize(input_message:)
    @input_message = input_message
  end

  def reset_input_message_to(message)
    @input_message = message
    @input = nil
  end

  def input
    @input ||= StringIO.new(input_message + "\n")
  end

  def output
    @output ||= StringIO.new
  end
end
