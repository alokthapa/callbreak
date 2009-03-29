require "test_helper"
class TestAppModelsCurrentcards < Test::Unit::TestCase
  
  def test_add_new_card
    ccards = CurrentCards.new
    card = Card.new(:Spades, :A)
    ccards.add(:n, card)
    assert(ccards.get_cards.include?(card), "Failure message.")
 end
 
 def test_moves_left
   ccards = CurrentCards.new
    ccards.add(:n, Card.new(:Spades, :A)).
           add(:e, Card.new(:Spades, 10))
           
    assert_equal(2, ccards.moves_left)

    ccards.add(:s, Card.new(:Spades, :K))
    assert_equal(1, ccards.moves_left)
    
    ccards.add(:w, Card.new(:Spades, :Q))
    
    assert_equal(0, ccards.moves_left)
 end
 
 def test_card_for
   ccards = CurrentCards.new
   ccards.add(:n, Card.new(:Spades, :A)).
          add(:e, Card.new(:Spades, 10))
  
  assert_equal(Card.new(:Spades, :A), ccards.card_for(:n))
  assert_nil(ccards.card_for(:s))
           
   
  
 end
 
 def test_get_cards
   ccards = CurrentCards.new

   ccards.add(:n, Card.new(:Spades, :A)).
          add(:e, Card.new(:Spades, 10)).
          add(:s, Card.new(:Diamond, 5)).
          add(:w, Card.new(:Clubs, 9))
  assert_equal([ Card.new(:Spades, :A), Card.new(:Spades, 10), 
                 Card.new(:Diamond, 5), Card.new(:Clubs, 9) ], ccards.get_cards)
 end
 
 
 def test_current_hand_winner
   ccards = CurrentCards.new

   ccards.add(:n, Card.new(:Spades, :A)).
          add(:e, Card.new(:Spades, 10)).
          add(:s, Card.new(:Diamond, 5)).
          add(:w, Card.new(:Clubs, 9))
          
  assert_equal(:n, ccards.calculate_hand_winner)
  end
  
end