require_relative "tic_tac_toe/errors"
require_relative "tic_tac_toe/cli"
require_relative "tic_tac_toe/session"
require_relative "tic_tac_toe/game"

module TicTacToe
  class << self
    def start_session!(interactor:, **opts)
      Session.start!(interactor: interactor, **opts)
    end
  end
end
