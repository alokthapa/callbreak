require "test_helper"
         
class TestCardUtility < Test::Unit::TestCase  
  include Cardutility
  
  def test_suits_without_win
    assert(suits_without_win.include?(:Hearts), "Failure message.")
    assert(suits_without_win.include?(:Clubs), "Failure message.")
    assert(suits_without_win.include?(:Diamonds), "Failure message.")
    assert_equal(false, suits_without_win.include?(:Spades))
    
  end
  
  
  def test_number_ace_cards
    assert_equal(1 , number_ace_cards( [Card.new(:Hearts, :A), Card.new(:Diamonds, :Q), Card.new(:Hearts,:J) ]))
    assert_equal(2 ,number_ace_cards( [Card.new(:Hearts, :A), Card.new(:Diamonds, :A), Card.new(:Hearts,:J) ]))
  end
  
  def test_highcard_combo
    assert_equal(1 , highcard_combo( [Card.new(:Hearts, :K), Card.new(:Hearts, :Q), Card.new(:Hearts,:J) ]))
    
    assert_equal(2 , highcard_combo( [Card.new(:Hearts, :K), Card.new(:Hearts, :Q), Card.new(:Diamonds,:J), Card.new(:Diamonds,:Q) ]))
    
    assert_equal(1 , highcard_combo( [Card.new(:Hearts, :K), Card.new(:Hearts, :Q), Card.new(:Diamonds,:J), Card.new(:Hearts,:J) ]))
  end
  
  def test_extra_winsuit
    assert_equal(0, extra_winsuit([Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades,:J) ]))
    assert_equal(1, extra_winsuit([Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades,:J),Card.new(:Spades,10) ]))
    assert_equal(2, extra_winsuit([Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades,:J),Card.new(:Spades,10),Card.new(:Spades,8) ]))
  end
end