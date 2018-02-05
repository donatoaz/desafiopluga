require './lib/standard'
require './lib/console'

# Abstraction for gameplay
class Game
  def initialize(ttt = TicTacToe::Standard.new(View::Console.new))
    @ttt = ttt
  end

  def start_game
    # print welcome message to user
    puts @ttt.welcome_message

    # loop through until the game is over
    until @ttt.game_is_over || @ttt.game_is_tie
      @ttt.render
      @ttt.run_turn
    end
    @ttt.render
    if @ttt.game_is_tie
    else
      # this does not belong here... correct later
      winner = @ttt.winning_player
      puts "#{winner} won the game!"
    end
  end
end

game = Game.new(TicTacToe::Standard.new(View::Console.new, '3x3',
                                    [
                                      { type: :human, marker: 'x',
                                        name: 'Donato' },
                                      { type: :computer, marker: 'o',
                                        level: :easy }
                                    ].each))

game.start_game
