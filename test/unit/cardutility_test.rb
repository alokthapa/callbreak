require "test/unit"
require "test_helper"

require "card"
require "rules"
require "player"
require "cardutility"
         
class TestApp < Test::Unit::TestCase
  include Cardutility
  
  
  def test_suits_without_win
    assert_equal( [:Hearts, :Clubs, :Diamond], suits_without_win() )
  end
  
  def test_number_ace_cards
    assert_equal(1 ,number_ace_cards( [Card.new(:Hearts, :A), Card.new(:Diamond, :Q), Card.new(:Hearts,:J) ]))
    assert_equal(2 ,number_ace_cards( [Card.new(:Hearts, :A), Card.new(:Diamond, :A), Card.new(:Hearts,:J) ]))
  end
  
  def test_highcard_combo
    assert_equal(1 , highcard_combo( [Card.new(:Hearts, :K), Card.new(:Hearts, :Q), Card.new(:Hearts,:J) ]))
    assert_equal(2 , highcard_combo( [Card.new(:Hearts, :K), Card.new(:Hearts, :Q), Card.new(:Diamond,:J), Card.new(:Diamond,:Q) ]))
    assert_equal(1 , highcard_combo( [Card.new(:Hearts, :K), Card.new(:Hearts, :Q), Card.new(:Diamond,:J), Card.new(:Hearts,:J) ]))
  end
  
  def test_extra_winsuit
    assert_equal(0, extra_winsuit([Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades,:J) ]))
    assert_equal(1, extra_winsuit([Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades,:J),Card.new(:Spades,10) ]))
    assert_equal(2, extra_winsuit([Card.new(:Spades, :A), Card.new(:Spades, :Q), Card.new(:Spades,:J),Card.new(:Spades,10),Card.new(:Spades,8) ]))
  end
end