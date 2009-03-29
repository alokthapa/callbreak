require "test/unit"
require "test_helper"


require "card"
require "rules"

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
    assert_equal(Card.new(:Hearts, :A),Rules.beats(Card.new(:Hearts, :A), Card.new(:Hearts, :J)))
    assert_equal(Card.new(:Hearts, :J), Rules.beats( Card.new(:Hearts, 5), Card.new(:Hearts, :J)))
        
    #of winsuit
    assert_equal(Card.new(:Spades, 4), Rules.beats(Card.new(:Spades, 4), Card.new(:Hearts, 3)))
    assert_equal(Card.new(:Spades, 4), Rules.beats(Card.new(:Hearts, 3), Card.new(:Spades, 4)))

    #different suit
    assert_equal(Card.new(:Hearts, 5), Rules.beats(Card.new(:Hearts, 5), Card.new(:Clubs, 10), Card.new(:Hearts, 3)))
    assert_equal(Card.new(:Clubs, 2),Rules.beats(Card.new(:Hearts, 5), Card.new(:Clubs, 2), Card.new(:Clubs, 5)))
  end
  
  def test_beats_all

    #simple
    assert_equal(Card.new(:Hearts, :A), Rules.beats_all([Card.new(:Hearts, :A)]))
    assert_equal(Card.new(:Hearts, :A), Rules.beats_all([Card.new(:Hearts, :A), Card.new(:Clubs, :J)]))
    assert_equal(Card.new(:Hearts, :A), Rules.beats_all([Card.new(:Hearts, :A), Card.new(:Hearts, :Q), Card.new(:Clubs, :J)]))
    
    #has winsuit
    assert_equal(Card.new(:Spades, 3), Rules.beats_all([Card.new(:Hearts, :A), Card.new(:Spades, 3), Card.new(:Clubs, :J)]))
    
    #requires first suit
    assert_equal(Card.new(:Hearts, :J), Rules.beats_all([Card.new(:Hearts, 2), Card.new(:Clubs, 5), Card.new(:Hearts, :J), Card.new(:Diamond, 10)]))
  end
  
  def test_valid_moves

    #empty pcards
    assert_equal([Card.new(:Diamond, :A), Card.new(:Hearts, 10)], Rules.valid_moves([Card.new(:Diamond, :A), Card.new(:Hearts, 10)], []))
  
    #no cards of given suit
    assert_equal([Card.new(:Diamond, :A), Card.new(:Hearts, 10)], Rules.valid_moves([Card.new(:Diamond, :A), Card.new(:Hearts, 10)], [Card.new(:Clubs, 10)]))
    
    #cards of given suit of higher order exists
    assert_equal([Card.new(:Diamond, :A), Card.new(:Diamond, :K)], Rules.valid_moves([Card.new(:Diamond,:A), Card.new(:Hearts, 10), Card.new(:Diamond, :K)], [Card.new(:Diamond, 10)]))
    
    #cards of given suit of lower order exists
    assert_equal([Card.new(:Diamond, 2), Card.new(:Diamond, 3)], Rules.valid_moves([Card.new(:Diamond, 2), Card.new(:Hearts, 10), Card.new(:Diamond, 3)], [Card.new(:Diamond, 10)]))

    #no cards of given first suit, but have winsuit cards
    assert_equal([Card.new(:Spades, :A), Card.new(:Spades, 10)],Rules.valid_moves([Card.new(:Diamond, :A), Card.new(:Spades, :A), Card.new(:Spades, 10), Card.new(:Hearts, 10)], [Card.new(:Clubs, 10)]))

    #no cards of given suit or winsuit
    assert_equal([Card.new(:Diamond, :A), Card.new(:Hearts, :A), Card.new(:Hearts, 10) ], Rules.valid_moves([Card.new(:Diamond, :A), Card.new(:Hearts, :A), Card.new(:Hearts, 10) ], [Card.new(:Clubs, 10)]))

    #no cards of given suit or winsuit
    assert_equal([Card.new(:Clubs, 10), Card.new(:Clubs, 9), Card.new(:Clubs, 2) ], 
    Rules.valid_moves([Card.new(:Hearts, :J), Card.new(:Hearts, 8), Card.new(:Hearts, 2), Card.new(:Clubs, 10), Card.new(:Clubs, 9), Card.new(:Clubs, 2) ], [Card.new(:Clubs, :J),Card.new(:Clubs, 8),Card.new(:Clubs, :A)]))

    #winsuit game
    assert_equal([Card.new(:Spades, 7), Card.new(:Spades, 5), Card.new(:Spades, 2) ], 
    Rules.valid_moves(
    [ Card.new(:Diamond, 5),Card.new(:Diamond, 2), Card.new(:Spades, 7), Card.new(:Spades, 5), Card.new(:Spades, 2) ], 
    [Card.new(:Spades, :A),Card.new(:Diamond, :K), Card.new(:Hearts, 2)]))

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
end