require 'minitest/autorun'
require './lib/board'

# Tests the board abstraction
class TestBoard < Minitest::Test
  def setup
    @board = Board.new('4x4')
  end

  def test_invalid_size
    err = assert_raises RuntimeError do
      foo_board = Board.new('Nx-')
    end
    assert_match(/Invalid size/, err.message)
  end

  def test_valid_board_creation_size
    assert_equal 16, @board.size
  end

  def test_range_validation_when_is_within
    (0..(@board.num_rows - 1)).to_a.each do |row|
      (0..(@board.num_cols - 1)).to_a.each do |col|
        assert @board.within_range(row, col)
      end
    end
  end

  def test_range_validation_when_is_not_within
    refute @board.within_range(@board.num_rows, @board.num_cols)
  end

  def test_valid_board_initialization
    (0..@board.size - 1).to_a.each.to_s do |place|
      assert_equal place, @board[place]
    end
    assert_equal 2.to_s, @board[0, 2]
  end

  def test_invalid_move
    err = assert_raises RuntimeError do
      @board[1000, 1000] = 'x'
    end
    assert_match(/outside boundaries/i, err.message)
  end

  def test_valid_move
    (0..(@board.num_rows - 1)).to_a.each do |row|
      (0..(@board.num_cols - 1)).to_a.each do |col|
        @board[row, col] = 'x'
        assert_equal 'x', @board[row, col]
      end
    end
  end

  def test_available_spaces
    new_board = Board.new('2x2')
    new_board[0, 0] = 'x'
    new_board[1, 1] = 'o'
    assert_equal %w[1 2], new_board.available_spaces
  end

  def test_rows
    assert_equal [['0', '1', '2', '3'],
                  ['4', '5', '6', '7'],
                  ['8', '9', '10', '11'],
                  ['12', '13', '14', '15']], @board.rows
  end

  def test_columns
    assert_equal [['0', '4', '8', '12'],
                 ['1', '5', '9', '13'],
                 ['2', '6', '10', '14'],
                 ['3', '7', '11', '15']], @board.columns
  end

  def test_diagonals
    assert_equal [['0', '5', '10', '15'],
                  ['3', '6', '9', '12']], @board.diagonals
  end

  def test_all_filled
    (0..(@board.num_rows - 1)).to_a.each do |row|
      (0..(@board.num_cols - 1)).to_a.each do |col|
        @board[row, col] = 'x'
      end
    end
    assert @board.all_filled
  end

  def test_is_available
    @board[0] = 'x'
    refute @board.available?(0)
    assert @board.available?(1)
  end
end
