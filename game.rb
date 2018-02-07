require './lib/standard'
require './lib/console'
require './lib/slop/custom_options.rb'
require 'slop'

# Abstraction for gameplay
class Game
  def initialize(ttt = TicTacToe::Standard.new(View::Console.new))
    @ttt = ttt
  end

  def start_game
    puts @ttt.welcome_message
    until @ttt.game_is_over || @ttt.game_is_tie
      @ttt.run_turn
    end
    @ttt.render
    if @ttt.game_is_tie
      puts 'Ooops, seems like this is a TIE! Try again!'
    else
      puts "#{@ttt.winning_player} won the game!"
    end
  end
end

begin
  opts = Slop.parse do |o|
    o.intmax '-s', '--size', 'board size (eg say 3 for 3x3). Maximum is 5',
             default: 3, max: 5
    o.player '-p', '--players', 'list of players, separated by commas, in the '\
                               'format: human:name or computer:level, where '\
                               'level may be one of easy, medium or hard.',
             required: true, delimiter: ','
    o.bool '--web', 'Run a game server and play via a rest api'
    o.on '-h', '--help' do
      puts o
    end
  end
rescue Slop::Error => e
  puts e.message
  exit
end

# restrict the number of players for now...
if opts[:players].count > 3
  puts 'Woah, that\'s just too many cowboys for this rodeo... '\
    'Try 2 or 3 and have fun just like that...'
  exit
end

puts opts[:players].inspect

size = "#{opts[:size]}x#{opts[:size]}"
game = Game.new(TicTacToe::Standard.new(View::Console.new, size,
                                        opts[:players].each))

game.start_game
