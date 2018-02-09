require_relative 'tictactoe'
##
# Classic implementation of Tic Tac Toe
# see method rulebook for rules
class TicTacToe::Standard < TicTacToe

  # Best effort move means the AI will: 
  #  1. make a winning move, or
  #  2. make a blocking move (prevent another player from winning), or
  #  3. make a random move
  #  This method returns the move and a boolean value indicating if
  #   (true) if it was a randomized choice
  def best_effort_move(player)
    @board.available_spaces.each do |as|
      spot = as.to_i
      move_to(spot, player)
      # 1. checks if 'as' move ends the game, if it does, than it is the best move
      if game_is_over
        return as.to_i, false
      else
        move_to(spot, {marker: as})
        # 2. otherwise check if there is an opponent's move that would end the
        #  game, we don't want that, so let's play deffensive and block it
        opponent_markers = markers.select { |m| m !~ /^#{player[:marker]}$/ }
        opponent_markers.each do |m|
          move_to(spot, {marker: m})
          if game_is_over
            return as.to_i, false
          else
            move_to(spot, {marker: as})
          end
        end
      end
    end

    # if there is no winning move, pick a random out of the available_spaces
    return @board.available_spaces.sample.to_i, true
  end

  # Best move replicates steps 1 and 2 of best_effort_move
  #  however, it replaces the 3rd step with a minimax approach to optimum
  #  game move, that means that when given the opportunity, instead of making
  #  a randomized move it will make an "attack" move.
  #  1. Theory proves center move is best, so take it if available
  def best_move(player, _depth = 0)
    best_effort, i_was_just_guessing = best_effort_move(player)
    return best_effort unless i_was_just_guessing

    center = @board.size / 2
    # test if empty
    if @board.available?(center)
      return center, false
    else
    end
  end

  def game_is_over(b = @board)
    (@board.rows + @board.columns + @board.diagonals).each do |row|
      return true if row.uniq.length == 1
    end
    false
  end

  def game_is_tie(b = @board)
    !game_is_over(b) && @board.all_filled
  end

  # find out how to test this
  def winning_player
    return @current_player[:name] if @current_player[:type] == :human
    'Computer'
  end

  def rulebook
    @view.render_message(
      <<~RULEBOOK
      In order to win a player must fill in either horizontal,
      vertical or diagonal lines, in their entirety with his
      marker. If no player is able to accomplish this and no
      vacant spaces are left, the game is a tie.
      RULEBOOK
    )
  end
end
