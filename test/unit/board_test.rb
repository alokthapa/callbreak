require "test_helper"
class TestBoard < Test::Unit::TestCase
 
 def test_initialize
  assert(Board.new("alok"), "Failure message.")
  assert_raise(RuntimeError) { Board.new("..\\,,") }
 end
 
 def test_new_deal
   board = Board.new("alok")
   board.new_deal
   assert_equal(4, board.players.values.length)
   assert_equal(13,board.players.values[0].cards.length)
 end
  
  def test_setup_other_tricks
    board = Board.new("alok")
    board.setup_other_tricks
    assert(board.scorecard.current_round.called[:w] > 0, "Failure message.")
    assert(board.scorecard.current_round.called[:e] > 0, "Failure message.")
    
  end
  
  def test_setup_user_tricks
    board = Board.new("alok")
    board.setup_other_tricks
    board.setup_user_tricks(4)
    assert(board.scorecard.current_round.called[:s] > 0, "Failure message.")
  end
  
  def test_update_waiting_on
    board = Board.new("alok")
    board.update_waiting_on :e
    assert_equal(:e, board.waiting_on)
  end
 
  
  def test_next_player
    board = Board.new("alok")
    assert_equal(:e, board.next_player(:n))
    assert_equal(:s, board.next_player(:e))
    assert_equal(:w, board.next_player(:s))
    assert_equal(:n, board.next_player(:w))
  end
   
end
 