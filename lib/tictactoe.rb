require_relative 'board'

class TicTacToe

  ## 
  # Class constructor, creates basic engine for Tic Tac Toe
  # A.K.A Noughts and Crosses, across the pond
  #
  # view is the view component that should implement the methods: render(board) and
  # get_player_movement, which should return a play move
  # size must be in the form of NxN
  # players must be an Enumerator of the form: 
  # [{human: 'MARKER_CHAR'i, name: 'NAME'}, {computer: 'MARKER_CHAR'}, ...].each
  def initialize(view, size = '3x3', players = [{type: :human, marker: 'o',
                                                 name: 'John'}, 
                                                {type: :computer, marker: 'x',
                                                level: :medium}].each)
    @players = players
    @view = view
    @board = Board.new(size)
    @current_player = nil
  end

  def render
    @view.render_board(@board)
  end

  def get_player_move
    @view.read_move
  end

  def run_turn_non_blocking
    begin
      @current_player = @players.next
      spot = nil
      unless @current_player[:type] == :human
        spot = get_ai_move(@current_player).to_i
        move_to(spot, @current_player)
      end
    rescue StopIteration => e
      @players.rewind
      retry
    end
  end

  def run_turn
    render
    begin
      @current_player = @players.next
      spot = nil
      if @current_player[:type] == :human
        @view.render_message("Turn of: #{@current_player[:name]}")
        while invalid_movement(spot = get_player_move.to_i, @current_player)
          @view.render_message("Invalid move, try again")
        end
      else
        spot = get_ai_move(@current_player).to_i
      end
      move_to(spot, @current_player)
    rescue StopIteration => e
      @players.rewind
      retry
    end
  end

  def get_ai_move(player)
    # hard coding difficulty level -- find a way to extract this
    case player[:level]
    when :easy
      return @board.available_spaces.sample
    when :medium
      spot, was_move_random = best_effort_move(player)
      return spot
    else
      return best_move(player)
    end
  end

  # This method has a code smell, ideally, we should not be
  #  checking if it is human or computer, but ruby does not
  #  allow easily for deep copying objects, to the AI needs
  #  to run its tests on the actual @board object.
  def invalid_movement(spot, player)
    !spot.to_s.match(/\d/) ||       # make sure it's number
      !@board.within_range(spot) || # make sure it's within
      (player[:type] == :human &&   # if it human, do not allow
       !@board.available?(spot))    # to mark a taken spot 
  end

  def move_to(spot, player)
    raise "Invalid movement to #{spot}" if invalid_movement(spot, player)
    @board[spot] = player[:marker]
  end

  def markers
    @players.map {|player| player[:marker]}
  end

  def welcome_message
    @view.render_message(
      <<~WELCOME
      Welcome! This is a game of Tic Tac Toe!
      See the rules below for any variation of the game 

      #{rulebook}
      WELCOME
    )
  end

  def ending_message
    @view.render_message(
      <<~GAME_OVER
      Game is over!
      GAME_OVER
    )
  end

  def best_effort_move(player)
    raise NotImplementedError, 'Consumer must implement'
  end

  def best_move(player)
    raise NotImplementedError, 'Consumer must implement'
  end
end

