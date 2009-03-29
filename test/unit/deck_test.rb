require "test/unit"
require "test_helper"

require "card"
require "player"
require "rules"
require "deck"


class TestDeck < Test::Unit::TestCase

  def test_deck_initialize
   assert_equal(Card.from_id(0), Deck.new(false).cards[0])
   assert_not_equal(Card.from_id(0), Deck.new.cards[0])
  end
  
  def test_get_card
    deck = Deck.new
    
    assert_equal(52,deck.cards.length)
    deck.get_card
    assert_equal(51, deck.cards.length)
  end
  
end
