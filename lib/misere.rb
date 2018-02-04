class Rules::Misere
  def initialize
  end

  def welcome_message
    <<~WELCOME
    Welcome! This is a misère style game of Tic Tac Toe!
    I will give you the rules below, but at any time
    you may press ESC for help.

    #{rulebook}
    WELCOME
  end

  def rulebook
    <<~RULEBOOK
    In the Misère version of Tic Tac Toe, forget what you
    think is right. The winner is the player who is able to
    NOT fill in either vertical, horizontal or diagonal lines
    in their entirety with his marker, and must do his best to
    force the opponent to do so himself.
    RULEBOOK
  end
end
