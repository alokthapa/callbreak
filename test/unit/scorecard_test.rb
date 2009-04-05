require "test_helper"

class TestAppModelsScorecard < Test::Unit::TestCase

  def test_initialize
    scorecard = Scorecard.new
    assert_equal(Array.new, scorecard.rscores)
  end
  
  def test_add
    scorecard = Scorecard.new
    scorecard.add_new(1)
    assert(scorecard.rscores.include?(1), "Failure message.")
  end
  
  def test_complete_rounds
    scorecard = Scorecard.new
    rs1 = Roundscore.new
    rs1.hash[:n]= 8
    rs1.hash[:s]= 2

    scorecard.add_new(rs1)
    assert_equal([], scorecard.complete_rounds)
    rs1.hash[:w]=1
    rs1.hash[:e]= 2
    assert_equal(1, scorecard.complete_rounds.length)
  end
  
  def test_get_for_player
    scorecard = Scorecard.new                        
    scorecard.add_new(Roundscore.new.add_called_points(:s, 4).add(:s, 5).add(:n, 8))
    scorecard.add_new(Roundscore.new.add_called_points(:s, 4).add(:s, 4).add(:n, 9))
    scorecard.add_new(Roundscore.new.add_called_points(:s, 4).add(:s, 3).add(:n, 10))
    scorecard.add_new(Roundscore.new.add_called_points(:s, 4).add(:s, 2).add(:n, 11))
   
    assert_equal(4.1+4 -4-4, scorecard.get_scorecard(:s))
  end
  
   def test_setup_round
     scorecard = Scorecard.new
     scorecard.setup_round [[:n,3], [:s,3],[:w,2],[:e,5]]
     rscore = scorecard.current_round
     assert_equal(3,rscore.called[:n])
     assert_equal(3,rscore.called[:s])
     assert_equal(2,rscore.called[:w])
     assert_equal(5,rscore.called[:e])
   end

  def test_setup_user_tricks
    scorecard = Scorecard.new
    scorecard.add_new Roundscore.new
    scorecard.setup_user_tricks(:s, 3)
    assert_equal(3,scorecard.current_round.called[:s])
  end
  
  def test_current_round
    scorecard = Scorecard.new
    rscore = Roundscore.new
    scorecard.add_new rscore 
    assert_equal(rscore, scorecard.current_round)
  end
  
  def test_rounds
    scorecard = Scorecard.new
    scorecard.add_new Roundscore.new
    assert_equal(1,scorecard.rounds)
    scorecard.add_new Roundscore.new
    assert_equal(2,scorecard.rounds)
  end
end