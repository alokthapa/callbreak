require "test_helper"
class TestAppModelsRules < Test::Unit::TestCase

  def test_valid_suit_moves
    assert_equal([Card.new(:Hearts, :A)], 
      Rules.valid_suit_moves( [ Card.new(:Hearts, 10)], 
                              [ Card.new(:Hearts, 4),
                                Card.new(:Hearts, :A)]))
    
    assert_equal([Card.new(:Hearts, 4),Card.new(:Hearts, 5)], Rules.valid_suit_moves([Card.new(:Hearts, 10)], [Card.new(:Hearts, 4),Card.new(:Hearts, 5)]))
  end

  def test_beats
    #same suit
    assert_equal( Card.new(:Hearts, :A),
                  Rules.beats(Card.new(:Hearts, :A), 
                            Card.new(:Hearts, :J)))
                            
    assert_equal( Card.new(:Hearts, :J), 
                  Rules.beats(Card.new(:Hearts, 5), 
                              Card.new(:Hearts, :J)))
        
    #of winsuit
    assert_equal( Card.new(:Spades, 4), 
                  Rules.beats(Card.new(:Spades, 4), 
                              Card.new(:Hearts, 3)))
                              
    assert_equal( Card.new(:Spades, 4), 
                  Rules.beats(Card.new(:Hearts, 3), 
                              Card.new(:Spades, 4)))

    #different suit
    assert_equal(Card.new(:Hearts, 5), Rules.beats(Card.new(:Hearts, 5), Card.new(:Clubs, 10), Card.new(:Hearts, 3)))
    assert_equal(Card.new(:Clubs, 2),Rules.beats(Card.new(:Hearts, 5), Card.new(:Clubs, 2), Card.new(:Clubs, 5)))
  end
  
  def test_beats_all?
  
    assert(Rules.beats_all?(Card.new(:Hearts, :A), [Card.new(:Hearts, :J), Card.new(:Clubs, 2)]), "Failure message.")
    
    assert(Rules.beats_all?(Card.new(:Hearts, :J), [Card.new(:Hearts, 2), Card.new(:Clubs, 5), Card.new(:Diamonds, 10)]), "fail")
    
  end
  
  def test_beats_all

    #simple
    assert_equal(Card.new(:Hearts, :A), Rules.beats_all([Card.new(:Hearts, :A)]))
    assert_equal(Card.new(:Hearts, :A), Rules.beats_all([Card.new(:Hearts, :A), Card.new(:Clubs, :J)]))
    assert_equal(Card.new(:Hearts, :A), Rules.beats_all([Card.new(:Hearts, :A), Card.new(:Hearts, :Q), Card.new(:Clubs, :J)]))
    
    #has winsuit
    assert_equal(Card.new(:Spades, 3), Rules.beats_all([Card.new(:Hearts, :A), Card.new(:Spades, 3), Card.new(:Clubs, :J)]))
    
    #requires first suit
    assert_equal(Card.new(:Hearts, :J), Rules.beats_all([Card.new(:Hearts, 2), Card.new(:Clubs, 5), Card.new(:Hearts, :J), Card.new(:Diamonds, 10)]))
  end
  
  def test_valid_moves

    #empty pcards
    assert_equal([Card.new(:Diamonds, :A), Card.new(:Hearts, 10)], Rules.valid_moves([Card.new(:Diamonds, :A), Card.new(:Hearts, 10)], []))
  
    #no cards of given suit
    assert_equal([Card.new(:Diamonds, :A), Card.new(:Hearts, 10)], Rules.valid_moves([Card.new(:Diamonds, :A), Card.new(:Hearts, 10)], [Card.new(:Clubs, 10)]))
    
    #cards of given suit of higher order exists
    assert_equal([Card.new(:Diamonds, :A), Card.new(:Diamonds, :K)], Rules.valid_moves([Card.new(:Diamonds,:A), Card.new(:Hearts, 10), Card.new(:Diamonds, :K)], [Card.new(:Diamonds, 10)]))
    
    #cards of given suit of lower order exists
    assert_equal([Card.new(:Diamonds, 2), Card.new(:Diamonds, 3)], Rules.valid_moves([Card.new(:Diamonds, 2), Card.new(:Hearts, 10), Card.new(:Diamonds, 3)], [Card.new(:Diamonds, 10)]))

    #no cards of given first suit, but have winsuit cards
    assert_equal([Card.new(:Spades, :A), Card.new(:Spades, 10)],Rules.valid_moves([Card.new(:Diamonds, :A), Card.new(:Spades, :A), Card.new(:Spades, 10), Card.new(:Hearts, 10)], [Card.new(:Clubs, 10)]))
    
    #no cards of given first suit and sb else played winsuit, have winsuit that wins
    assert_equal([Card.new(:Spades, :A)],Rules.valid_moves([Card.new(:Diamonds, :A), Card.new(:Spades, :A), Card.new(:Spades, 2), Card.new(:Hearts, 10)], [Card.new(:Clubs, 10), Card.new(:Spades, 9)]))
    
    #no cards of given first suit and sb else played winsuit, no winsuit that wins, 
    assert_equal( [ Card.new(:Diamonds, :A), 
                    Card.new(:Spades, 2), 
                    Card.new(:Hearts, 10)],
                    Rules.valid_moves([ Card.new(:Diamonds, :A), 
                                        Card.new(:Spades, 2), 
                                        Card.new(:Hearts, 10)], 
                                      [ Card.new(:Clubs, 10), 
                                        Card.new(:Spades, 9)]))
    

    #no cards of given suit or winsuit
    assert_equal([Card.new(:Diamonds, :A), Card.new(:Hearts, :A), Card.new(:Hearts, 10) ], Rules.valid_moves([Card.new(:Diamonds, :A), Card.new(:Hearts, :A), Card.new(:Hearts, 10) ], [Card.new(:Clubs, 10)]))

    #no cards of given suit or winsuit
    assert_equal([Card.new(:Clubs, 10), Card.new(:Clubs, 9), Card.new(:Clubs, 2) ], 
    Rules.valid_moves([Card.new(:Hearts, :J), Card.new(:Hearts, 8), Card.new(:Hearts, 2), Card.new(:Clubs, 10), Card.new(:Clubs, 9), Card.new(:Clubs, 2) ], [Card.new(:Clubs, :J),Card.new(:Clubs, 8),Card.new(:Clubs, :A)]))

    #winsuit game
    assert_equal([Card.new(:Spades, 7), Card.new(:Spades, 5), Card.new(:Spades, 2) ], 
    Rules.valid_moves(
    [ Card.new(:Diamonds, 5),Card.new(:Diamonds, 2), Card.new(:Spades, 7), Card.new(:Spades, 5), Card.new(:Spades, 2) ], 
    [Card.new(:Spades, :A),Card.new(:Diamonds, :K), Card.new(:Hearts, 2)]))

    assert_equal([Card.new(:Spades, 7), Card.new(:Spades, 6), Card.new(:Spades, 2) ], 
    Rules.valid_moves(
    [ Card.new(:Spades, 7),Card.new(:Spades, 6), Card.new(:Spades, 2), Card.new(:Hearts, 5), Card.new(:Clubs, 2) ], 
    [Card.new(:Spades, 4),Card.new(:Spades, :Q), Card.new(:Spades, :A)]))

    #cards of first suit, but winsuit played
    assert_equal([Card.new(:Clubs, :Q), Card.new(:Clubs, 2)], 
     Rules.valid_moves(
     [ Card.new(:Spades, 7),Card.new(:Spades, 6), Card.new(:Spades, 2), Card.new(:Hearts, 5), Card.new(:Clubs, :Q), Card.new(:Clubs, 2) ], 
     [Card.new(:Clubs, 4),Card.new(:Spades, :Q), Card.new(:Clubs, :J)]))

    #winsuit game, have winning and losing too, should only return winning
    assert_equal([Card.new(:Spades, :A), Card.new(:Spades, :Q)], 
      Rules.valid_moves(
      [Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades, 7), Card.new(:Spades, 6), Card.new(:Spades, 2), Card.new(:Hearts, 5), Card.new(:Clubs, :Q), Card.new(:Clubs, 2) ], 
      [Card.new(:Spades, 10),Card.new(:Spades, 7), Card.new(:Spades, 5)]))
        
  end
  
# 
# dirncardCard: Diamonds KdirecardCard: Diamonds 3dirscardCard: Diamonds 5dirwcardCard: Diamonds 4
# dirncardCard: Diamonds AdirecardCard: Diamonds 8dirscardCard: Diamonds 6dirwcardCard: Spades 4
# dirwcardCard: Clubs 10dirncardCard: Clubs JdirecardCard: Clubs QdirscardCard: Clubs K
# dirscardCard: Diamonds 9dirwcardCard: Hearts KdirncardCard: Diamonds 2direcardCard: Diamonds Q
# direcardCard: Diamonds 10dirscardCard: Spades 7dirwcardCard: Hearts 2dirncardCard: Diamonds 7
# dirscardCard: Hearts 6dirwcardCard: Hearts 7dirncardCard: Hearts 9direcardCard: Hearts A
# direcardCard: Hearts 3dirscardCard: Hearts JdirwcardCard: Clubs 8dirncardCard: Hearts Q
# dirncardCard: Hearts 5direcardCard: Hearts 4dirscardCard: Hearts 8dirwcardCard: Clubs 2
# rclone is #<Roundscore:0x240d218>
# 
end