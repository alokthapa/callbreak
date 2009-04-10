require "test_helper"
class TestParaniod < Test::Unit::TestCase

  def test_initialize
    player = Paranoid.new("alok",:n)
    assert_equal("alok", player.name)
    assert_equal([], player.cards)
  end
  
  def test_heuristics_score
    player = Paranoid.new("al",:n)
    assert(player.heuristics_score(Card.new(:Hearts, :A)) > player.heuristics_score(Card.new(:Hearts, 5)), "Failure message.")
    assert(player.heuristics_score(Card.new(:Spades, 2)) > player.heuristics_score(Card.new(:Hearts, :J)), "Failure message.")
  end
  
  
  def test_too_many_choices
    cards = [Card.new(:Spades, :A), Card.new(:Hearts, 5), Card.new(:Hearts, :K),
             Card.new(:Clubs, 4), Card.new(:Clubs, 3), Card.new(:Clubs, 10), Card.new(:Diamonds, 8),
             Card.new(:Diamonds, :A), Card.new(:Diamonds, :K)]
    p = Paranoid.new("a", :n)
    assert_equal(Card.new(:Hearts, 5), p.too_many_choices(cards))
  end
end