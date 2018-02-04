# implementation of a NxN tic tac toe board
class Board
  def initialize(size = '3x3')
    if match = size.match(/(\d+)x(\d+)/i)
      (m, n) = match.captures
      raise 'Invalid size: not square NxN' if m != n

      # Create our internal model of the board by filling each field
      #  sequentially
      size = m.to_i * n.to_i
      @board = (0..size - 1).to_a.map(&:to_s)
    else
      raise 'Invalid size: not MxN'
    end
  end

  # syntatic sugar to get board elements in either a linear position
  #  or a row, col idiom
  def [](*args)
    raise 'Invalid arguments' if args.size > 2
    if args.size == 2
      @board[_rc_to_spot(args[0], args[1])]
    else
      @board[args[0]]
    end
  end

  # syntatic sugar to set board elements in either a linear position
  #  or a row, col idiom
  def []=(*args)
    if args.size == 3
      (r, c, v) = args
      raise 'Outside boundaries' unless within_range(r, c)
      @board[_rc_to_spot(r, c)] = v
    elsif args.size == 2
      (p, v) = args
      raise 'Outside boundaries' if p > size
      @board[p] = v
    else
      raise 'Invalid arguments'
    end
  end

  def size
    @board.length
  end

  def num_rows
    Math.sqrt(size).to_i
  end

  def num_cols
    num_rows
  end

  def within_range(r, c = nil)
    if c.nil?
      r >= 0 && r < size
    else
      r >= 0 &&
        r < num_rows &&
        c >= 0 &&
        c < num_rows
    end
  end

  def available_spaces
    @board.select { |e| e =~ /\d+/ }
  end

  def rows
    @board.each_slice(num_cols).to_a
  end

  def columns
    # to ease the implementation, let's use the Matrix module
    (0..(num_cols - 1)).collect do |c|
      @board.select.with_index { |_v, i| i % num_cols == c }
    end
  end

  def diagonals
    first = (0..(num_cols - 1)).collect { |i| rows[i][i] }
    second = (0..(num_cols - 1)).collect { |i| rows[i][num_cols - 1 - i] }
    [first, second]
  end

  def all_filled
    @board.all? { |v| v !~ /\d+/ }
  end

  def available?(p)
    within_range(p) && @board[p] == p.to_s
  end

  private

  def _rc_to_spot(r, c)
    r * num_cols + c
  end
end

