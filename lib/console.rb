class View
end

class View::Console
  def initialize
  end

  def render_message(text)
    puts text
  end

  def render_board(board)
    (0..(board.num_rows - 1)).to_a.each do |row|
      (0..(board.num_cols - 1)).to_a.each do |col|
        print '|' if col.zero?
        print " #{_padding_l(board, row, col)}#{board[row, col]} |"
      end
      puts ''
      puts ''
    end
  end

  def _padding_l(board, row, col)
    pad = board.size.to_s.length - board[row, col].length
    if pad > 0
      ' ' * pad
    else
      ''
    end
  end

  def read_move
    gets.chomp
  end

  def help
    puts 'Each field is identified by its number.'
  end
end
