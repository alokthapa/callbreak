require "test_helper"

class TestCda < Test::Unit::TestCase
  
  def included_in?(vals, arr)
    vals.all? { |val| arr.include? val}
  end
  
  def test_included_in
    assert(included_in?([1, 2, 3], [1, 2, 3, 4]), "Failure message.")
    assert_equal(false, included_in?([1, 2, 3, 8], [1, 2, 3, 4]))
  end
  
  def test_initalize
    cda = Cda.new(:n)
    assert_equal(:n, cda.dir)    
    assert(included_in?([:s, :w, :e],cda.others), "fail")
    assert_equal(false,cda.others.include?(:n))
  end
  
  def test_initialize_cardhash
    cda = Cda.new(:n)
    assert_equal(52, cda.ds.length)
    (0..51).each do |id|
      assert(included_in?([:s, :n, :e, :w], cda.ds[id] ), "Failure message.") 
    end
  end
  
  def test_cards_smaller_than
    cda = Cda.new(:n)
    assert_equal([], cda.cards_smaller_than(Card.new(:Hearts, 2)))
    assert(included_in?([Card.new(:Hearts,2),Card.new(:Hearts,3), Card.new(:Hearts,4)],cda.cards_smaller_than(Card.new(:Hearts, 5))), "fail")
  end
  
  def test_all_cards_of_suit
    cda = Cda.new(:n)
    
    assert(included_in?([  Card.new(:Hearts, 2),
                    Card.new(:Hearts, 3),
                    Card.new(:Hearts, 4),
                    Card.new(:Hearts, 5),
                    Card.new(:Hearts, 6),
                    Card.new(:Hearts, 7),
                    Card.new(:Hearts, 8),
                    Card.new(:Hearts, 9),
                    Card.new(:Hearts, 10),
                    Card.new(:Hearts, :J),
                    Card.new(:Hearts, :Q),
                    Card.new(:Hearts, :K)], cda.all_cards_of_suit(:Hearts)), "Failure message.")
  end
  

  def test_add_player
    cda = Cda.new(:n)
    cda.add_player(Card.from_id(1))
    assert_equal([:n], cda.ds[1])
  end
  
  def test_add_played
    cda = Cda.new(:n)
    cda.add_played(:s, Card.from_id(1))
    assert(included_in?([:played, :s],cda.ds[1] ),"fail")
  end

  def test_remove_dir
    cda = Cda.new(:n)
    cda.remove_dir(:s, Card.from_id(1))
    assert_equal(false,cda.ds[1].include?(:s))
    assert(included_in?([:w, :e], cda.ds[1]), "Failure message.")
  end
  

end
