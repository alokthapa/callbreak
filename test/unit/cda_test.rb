require "test_helper"

class TestCda < Test::Unit::TestCase
  
  def included_in?(vals, arr)
    vals.all?{ |val| arr.include?(val)}
  end
  
  def test_included_in
    assert(included_in?([1, 2], [1, 2, 3, 4]), "Failure message.")
    assert_equal(false, included_in?([1, 2, 3, 8], [1, 2, 3, 4]))
  end
  
  def test_initalize
    cda = Cda.new(:n)
    assert_equal(:n, cda.dir)    
    assert(included_in?([:s, :w, :e],cda.others), "fail")
    assert_equal(false,cda.others.include?(:n))
  end
  
  def test_initialize_tags
    cda = Cda.new(:n)
    (0..51).each do |id|
      assert(included_in?([:s, :n, :e, :w], cda.get_tags(Card.from_id(id)) ), "Failure message.") 
    end
  end
  
  def test_cards_smaller_than
    cda = Cda.new(:n)
    assert_equal([], cda.cards_smaller_than(Card.new(:Hearts, 2)))
    assert(included_in?([Card.new(:Hearts,2),Card.new(:Hearts,3), Card.new(:Hearts,4)],cda.cards_smaller_than(Card.new(:Hearts, 5))), "fail")
  end
  
  def test_cards_higher_than
    cda = Cda.new(:n)
    high_cards = cda.cards_higher_than(Card.new(:Hearts, :A))
    assert_equal([],high_cards)
    high_cards = cda.cards_higher_than(Card.new(:Hearts, :J))
    assert(high_cards.include?(Card.new(:Hearts, :A)), "Failure message.")
    assert(high_cards.include?(Card.new(:Hearts, :K)), "Failure message.")
    assert(high_cards.include?(Card.new(:Hearts, :Q)), "Failure message.")
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
  
  def test_get_tags
    cda = Cda.new(:n)
    assert(included_in?(cda.directions,cda.get_tags(Card.from_id(1)) ), "Failure message.")
  end
  
  def test_add_played_ccards
    cda = Cda.new(:n)
    ccards = CurrentCards.new.add(:n, Card.from_id(1)).
                             add(:e, Card.from_id(2)).
                             add(:s, Card.from_id(3)).
                             add(:w, Card.from_id(4))

    cda.tag_played_ccards(ccards)                   
    assert(included_in?([:played, :n], cda.get_tags(Card.from_id(1))), "Failure message.")
    assert(included_in?([:played, :e], cda.get_tags(Card.from_id(2))), "Failure message.")
    assert(included_in?([:played, :s], cda.get_tags(Card.from_id(3))), "Failure message.")
    assert(included_in?([:played, :w], cda.get_tags(Card.from_id(4))), "Failure message.")
  end

  def test_add_player
    cda = Cda.new(:n)
    cda.tag_player_card(Card.from_id(1))
    assert_equal([:n], cda.get_tags(Card.from_id(1)))
  end
  
  def test_add_played
    cda = Cda.new(:n)
    cda.tag_played_card(:s, Card.from_id(1))
    assert(included_in?([:played, :s],cda.get_tags(Card.from_id(1)) ),"fail")
  end

  def test_remove_tag
    cda = Cda.new(:n)
    cda.remove_tag(:s, Card.from_id(1))
    assert_equal(false,cda.get_tags(Card.from_id(1)).include?(:s))
    assert(included_in?([:w, :e], cda.get_tags(Card.from_id(1))), "Failure message.")
  end
  
  def test_remove_tags
    cda = Cda.new(:n)
    cda.remove_tags(:s, [Card.from_id(1),Card.from_id(2)] )
    assert_equal(false,cda.get_tags(Card.from_id(1)).include?(:s))
    assert_equal(false,cda.get_tags(Card.from_id(2)).include?(:s))
    assert(included_in?([:w, :e], cda.get_tags(Card.from_id(1))), "Failure message.")
    assert(included_in?([:w, :e], cda.get_tags(Card.from_id(2))), "Failure message.")
    
  end
  
  
  def test_get_cards_till
    cda = Cda.new(:n)
    assert_equal([  Card.new(:Hearts, 2), 
                    Card.new(:Hearts, 3), 
                    Card.new(:Hearts, 4)],
                  cda.get_cards_till(Card.new(:Hearts, 4),   
                                    [ Card.new(:Hearts, 2), 
                                      Card.new(:Hearts, 3), 
                                      Card.new(:Hearts, 4),
                                      Card.new(:Hearts, 7)]))
  end
  
 def test_update_not_same_suit
   cda = Cda.new(:n)
   ccards = CurrentCards.new.add(:s, Card.new(:Hearts, 2)).
                             add(:w, Card.new(:Spades, 10))
   cda.update_tags(ccards)
   assert_equal(false, cda.get_tags(Card.new(:Hearts, 4)).include?(:w))
   assert_equal(false, cda.get_tags(Card.new(:Hearts, :A)).include?(:w))
 end
 

 def test_get_current_winner
   cda = Cda.new(:n)
   ccards = CurrentCards.new
   ccards.add(:s, Card.new(:Hearts, 2)).
                             add(:w, Card.new(:Hearts, :J)).
                             add(:n, Card.new(:Hearts, 4))
   assert_equal(Card.new(:Hearts, :J), 
    cda.get_current_winner(Card.new(:Hearts, :J),ccards))
 end

  def test_update_no_higher_than
    cda = Cda.new(:n)
    ccards = CurrentCards.new
    ccards.add(:e, Card.new(:Hearts, 2)).
                              add(:s, Card.new(:Hearts, :J)).
                              add(:w, Card.new(:Hearts, 4))
                              
    cda.update_tags(ccards)
    
    assert_equal(false, cda.get_tags(Card.new(:Hearts, :Q)).include?(:w))
    assert_equal(false, cda.get_tags(Card.new(:Hearts, :K)).include?(:w))
    assert_equal(false, cda.get_tags(Card.new(:Hearts, :A)).include?(:w))
  end
  
  def test_update_no_spades_higher_than
    cda = Cda.new(:n)
    ccards = CurrentCards.new
    ccards.add(:e, Card.new(:Hearts, 2)).
                              add(:s, Card.new(:Spades, :J)).
                              add(:w, Card.new(:Clubs, 4))
                              
    cda.update_tags(ccards)
    
    #no cards of first suit
    assert_equal(false, cda.get_tags(Card.new(:Hearts, 4)).include?(:w))
    assert_equal(false, cda.get_tags(Card.new(:Hearts, 5)).include?(:w))
    assert_equal(false, cda.get_tags(Card.new(:Spades, :Q)).include?(:w))
    assert_equal(false, cda.get_tags(Card.new(:Spades, :K)).include?(:w))
    assert_equal(false, cda.get_tags(Card.new(:Spades, :A)).include?(:w))
    
    
  end

end
