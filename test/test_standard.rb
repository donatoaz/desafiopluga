require 'minitest/autorun'
require './lib/standard'
require './lib/console'

class TestStandard < Minitest::Test
  def setup
    @standard = TicTacToe::Standard.new(View::Console.new, '3x3',
                                        [{ type: :human, marker: 'x',
                                           name: 'John' },
                                         { type: :computer, marker: 'o',
                                           level: :medium }].each)
  end

  def test_game_is_over_random_sized_board_row
    n = rand(3..10)
    new_standard = TicTacToe::Standard.new(View::Console.new, "#{n}x#{n}")
    (0..n - 1).to_a.each do |spot|
      new_standard.move_to(spot, { type: :human, marker: 'x' })
    end

    assert new_standard.game_is_over
  end

  def test_game_is_over_random_sized_board_col
    n = rand(3..10)
    new_standard = TicTacToe::Standard.new(View::Console.new, "#{n}x#{n}")
    (0..n - 1).to_a.each do |spot|
      new_standard.move_to(spot + spot * n, { type: :human, marker: 'x' })
    end

    assert new_standard.game_is_over
  end

  def test_game_is_over_random_sized_board_diag
    n = rand(3..10)
    new_standard = TicTacToe::Standard.new(View::Console.new, "#{n}x#{n}")
    (0..n - 1).to_a.each do |spot|
      new_standard.move_to(spot + spot * (n - 1) + spot,
                           { type: :human, marker: 'x' })
    end

    assert new_standard.game_is_over
  end

  def test_game_is_tie
    n = [3, 5, 7, 9, 11].sample
    new_standard = TicTacToe::Standard.new(View::Console.new, "#{n}x#{n}")
    (0..(n * n - 1)).to_a.each do |spot|
      marker = ('a'..'z').to_a.sample
      new_standard.move_to(spot, { type: :human, marker: marker })
    end

    assert new_standard.game_is_tie
  end
end
