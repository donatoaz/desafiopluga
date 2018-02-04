require 'minitest/autorun'
require './lib/tictactoe'
require './lib/console'
require './lib/board'

class TestTicTacToe < Minitest::Test
  def setup
    @engine = TicTacToe.new(View::Console.new, '4x4',
                            [{ type: :human, marker: 'x' },
                             { type: :computer, marker: 'o' }].each)
  end

  def test_invalid_move_beyond_limits
    assert @engine.invalid_movement(1000, { type: :human })
    assert @engine.invalid_movement(1000, { type: :computer })
  end

  def test_valid_move
    refute @engine.invalid_movement(3, { type: :human })
  end

  def test_make_a_valid_move
    assert @engine.move_to(4, { type: :human, marker: 'x' })
  end

  def test_make_invalid_move_to_taken_field
    @engine.move_to(4, { type: :human, marker: 'x' })

    err = assert_raises RuntimeError do
      @engine.move_to(4, { type: :human, marker: 'x' })
    end
    assert_match(/invalid movement/i, err.message)
  end

  def test_make_invalid_move_to_taken_field_as_ai
    @engine.move_to(4, { type: :human, marker: 'x' })
    @engine.move_to(4, { type: :computer, marker: 'o' })
  end

  def test_ai_easy_move
    spot = @engine.get_ai_move({ level: :easy }).to_i
    # code smell -- testing as a human to assert it is
    #  making a final decision as to a valid field
    refute @engine.invalid_movement(spot, { type: :human })
  end

  def test_medium_not_implemented
    err = assert_raises NotImplementedError do
      @engine.get_ai_move({ level: :medium })
    end
    assert_match(/Consumer must implement/, err.message)
  end

  def test_hard_not_implemented
    err = assert_raises NotImplementedError do
      @engine.get_ai_move({ level: :hard })
    end
    assert_match(/Consumer must implement/, err.message)
  end
end
