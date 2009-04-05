require "test_helper"
class TestAppModelsRoundscore < Test::Unit::TestCase

  def test_add
    roundscore = RoundScore.new.add(:s, 4)
    assert_equal(4, roundscore[:s])
  end
  
  def test_add_called_points
    roundscore = RoundScore.new.add_called_points(:s, 4)
    assert_equal( 4, roundscore.called[:s])
  end
  
  def test_get_score_when_equal
    roundscore = RoundScore.new.add_called_points(:s, 4).add(:s, 4)
    assert_equal(4, roundscore.get_score[:s])
  end
  
  def test_complete_round
    roundscore = RoundScore.new
    roundscore.hash[:n]= 8
    roundscore.hash[:s]= 2
    assert_equal(false,roundscore.complete_round?)
    roundscore.hash[:w]=1
    roundscore.hash[:e]= 2
    assert_equal(true,roundscore.complete_round?)
    
  end

  def test_get_score_when_called_more_than_actual
    roundscore = RoundScore.new.add_called_points(:s, 4).add(:s, 2)
    assert_equal(-4, roundscore.get_score[:s])
  end
  
  
  def test_get_score_when_actual_more_than_called
    roundscore = RoundScore.new.add_called_points(:s, 4).add(:s, 8)
    assert_equal(4.4, roundscore.get_score[:s])
  end

  def test_add_one
    roundscore = RoundScore.new.add_called_points(:s, 4).add_one(:s)
    assert_equal(1, roundscore.hash[:s])
    
    roundscore.add_one(:s)
    assert_equal(2, roundscore.hash[:s])
  end
  
  def test_clone
    roundscore = RoundScore.new.add_called_points(:s, 4).add_one(:s)
    roundscore.add_card(:n, Card.from_id(1))
    rc  = roundscore.clone
    
    assert_equal(4,rc.called[:s])
    assert_equal(1,rc[:s])
    
    assert_equal([Card.from_id(1)], rc.current_cards.get_cards)

    rc.add_one(:s)
    rc.add_card(:e, Card.from_id(2))
    
    assert_equal(1,roundscore[:s])
    assert_equal(2,rc[:s])
    
    assert_equal([Card.from_id(1)], roundscore.current_cards.get_cards)
    
  end
  
end