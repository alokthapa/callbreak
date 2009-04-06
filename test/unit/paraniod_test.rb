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
end