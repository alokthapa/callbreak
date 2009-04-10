require "test_helper"

class TestCard < Test::Unit::TestCase
 include Cardutility
 
 def test_cardsuits
   assert_equal([ :Hearts,:Clubs, :Diamonds, :Spades], Card.suits)
 end
 
 def test_cardvalues
   assert_equal([:A,:K, :Q,:J,10,9,8,7,6,5,4,3,2], Card.values)
 end
 
 def test_card_from_id
   assert_equal(Card.new(:Hearts, :A),Card.from_id(0))
 end
 
 def test_cards_of_suit
   assert_equal([Card.new(:Hearts, :A), Card.new(:Hearts, :K)],Card.cards_of_suit([Card.new(:Hearts, :A),Card.new(:Hearts, :K), Card.new(:Spades, :A)]))
 end
 
  
  def test_same_suit
    assert(Card.new(:Hearts, :A).same_suit?(Card.new(:Hearts, :Q)), "Failure message.")
    assert_equal(false,Card.new(:Hearts, :A).same_suit?(Card.new(:Spades, :A)))
    
  end
 
 def test_initialize
   card = Card.new(:Spades, :A)
   assert_equal(:Spades, card.suit)
   assert_equal(:A, card.value)
   assert_equal(39,card.id)
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