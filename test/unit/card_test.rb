require "test/unit"
require "test_helper"

require "card"
require "player"
require "rules"


class TestCard < Test::Unit::TestCase
 include Cardutility
 
  def Card.suits
    [:Hearts, :Diamonds, :Spades,:Clubs]
  end
  
  def test_fromid
    assert_equal(Card.new(:Hearts, :A), Card.from_id(0))
    assert_equal(Card.from_id(1) ,Card.new(:Hearts, :K))
    assert_equal(Card.from_id(13),Card.new(:Diamonds, :A))
    assert_equal(Card.from_id(26),Card.new(:Spades, :A))
    assert_equal(Card.from_id(39),Card.new(:Clubs, :A))
  end
  
 def test_id
   assert_equal(0,Card.new(:Hearts, :A).id)
   assert_equal(1,Card.new(:Hearts, :K).id)
   assert_equal(13,Card.new(:Diamonds, :A).id)
   assert_equal(26,Card.new(:Spades, :A).id)
   assert_equal(39,Card.new(:Clubs, :A).id)
 end
 
 def test_initialize
   card = Card.new(:Spades, :A)
   assert_equal(:Spades, card.suit)
   assert_equal(:A, card.value)
 end
 
  def test_equality
    card  = Card.new(:Spades, :A)
    other = Card.new(:Hearts, :J)
    card2 = Card.new(:Spades, :A)
    
    assert_equal(card, card2)
    assert_not_equal(card, other)
  end
  
  def test_card_create
    card = Card.new(:Spades, :A)
    assert_equal(:Spades,card.suit)
    assert_equal(:A, card.value)
  end
  
  def test_of_suit
    card = Card.new(:Spades, :A)
    assert(card.of_suit?(:Spades), "Failure message.")
  end
  
  def test_cards_of_suit
    cards = [ Card.new(:Spades, :A), Card.new(:Diamonds, :J), 
              Card.new(:Clubs, 5), Card.new(:Spades, 10)]
    filtered = Card.cards_of_suit(cards, :Spades)
    assert_equal(2,filtered.length)
    assert_equal(Card.new(:Spades, :A) , filtered[0])
    assert_equal(Card.new(:Spades, 10), filtered[1])
    
  end
  
  def test_higher_order
    card = Card.new(:Spades, 10)
    card_lo = Card.new(:Spades, 5) 
    card_hi = Card.new(:Spades, :A)

    assert(card.higher_order_than(card_lo), "Failure message.")
    assert(!card.higher_order_than(card_hi), "Failure message.")
  end
    
end 