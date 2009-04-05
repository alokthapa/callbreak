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
    ccards = Currentcard.new.add(:n, Card.from_id(1)).
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
   ccards = Currentcard.new.add(:s, Card.new(:Hearts, 2)).
                             add(:w, Card.new(:Spades, 10))
   cda.update_tags(ccards)
   assert_equal(false, cda.get_tags(Card.new(:Hearts, 4)).include?(:w))
   assert_equal(false, cda.get_tags(Card.new(:Hearts, :A)).include?(:w))
 end
 

 def test_get_current_winner
   cda = Cda.new(:n)
   ccards = Currentcard.new
   ccards.add(:s, Card.new(:Hearts, 2)).
                             add(:w, Card.new(:Hearts, :J)).
                             add(:n, Card.new(:Hearts, 4))
   assert_equal(Card.new(:Hearts, :J), 
    cda.get_current_winner(Card.new(:Hearts, :J),ccards))
 end

  def test_update_no_higher_than
    cda = Cda.new(:n)
    ccards = Currentcard.new
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
    ccards = Currentcard.new
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
  
  def test_make_cards_from_pairs
    cda = Cda.new(:n)
    
    assert(cda.make_cards_from_pairs([0, [:n], [1, [:n, :w]]]).include?(Card.from_id(0)), "Failure message.")
    
    assert(cda.make_cards_from_pairs([0, [:n], [1, [:n, :w]]]).include?(Card.from_id(1)), "Failure message.")
  end
  
  def test_get_only
    cda = Cda.new(:n)
    cda.tag_player_card(Card.new(:Spades, :A))
    assert(cda.only_for(:n).include?(Card.new(:Spades, :A)), "Failure message.")
    
    ccards = Currentcard.new.add(:s, Card.new(:Hearts, :K)).
                              add(:w, Card.new(:Hearts, 10)).
                              add(:n, Card.new(:Hearts, 8)).
                              add(:e, Card.new(:Hearts, 2))
    cda.update_tags(ccards)

    assert(cda.only_for(:s).include?(Card.new(:Hearts, :A)), "Failure message.")
  end
  
  def test_combination
    cda = Cda.new(:n)
    assert_equal(2, cda.combination([Card.from_id(1),Card.from_id(2),Card.from_id(3),Card.from_id(4)], 2).length)
    assert_equal(2, cda.combination([Card.from_id(1),Card.from_id(2),Card.from_id(3),Card.from_id(4)], 2, [Card.from_id(1)]).length)
    
    assert_equal(false, cda.combination([Card.from_id(1),Card.from_id(2),Card.from_id(3),Card.from_id(4)], 2, [Card.from_id(1)]).include?(Card.from_id(1)))
  end

  def test_maybe
    cda = Cda.new(:n)
    cda.tag_player_card(Card.new(:Spades, :A))
    assert(cda.maybe(:n).include?(Card.new(:Hearts, :A)), "Failure message.")
    assert(!cda.maybe(:s).include?(Card.new(:Spades, :A)), "Failure message.")
    
    cda.tag_played_card(:s, Card.new(:Spades, :K))
    assert_equal(false,cda.maybe(:n).include?(Card.new(:Spades, :K)))
    
    
  end
  
  def test_tag_player_cards
    cda = Cda.new(:n)
    cda.tag_player_cards([Card.from_id(0),Card.from_id(1),Card.from_id(2)])
    assert(cda.only_for(:n).include?(Card.from_id(0)), "fail")
    assert(cda.only_for(:n).include?(Card.from_id(1)), "fail")
    assert(cda.only_for(:n).include?(Card.from_id(2)), "fail")
    
  end
  
  def test_generate_model_not_include_player_cards

    cda = Cda.new(:n)
    cda.tag_player_cards((0..12).map{|id| Card.from_id(id)})
    gmodel = cda.generate_domain_model(13)
    
    assert(!gmodel[:s].include?(Card.from_id(0)), "Failure message.")
    assert(!gmodel[:e].include?(Card.from_id(0)), "Failure message.")
    assert(!gmodel[:w].include?(Card.from_id(0)), "Failure message.")
  end
  
  def test_generate_model_length_eq
    cda = Cda.new(:n)
    gmodel = cda.generate_domain_model(13)
    assert_equal(13,gmodel[:s].length)
    assert_equal(13,gmodel[:w].length)
    assert_equal(13,gmodel[:e].length)
  end
  
  def test_generate_model_only_for
    cda = Cda.new(:n)
    ccards = Currentcard.new.add(:s, Card.new(:Hearts, :K)).
                              add(:w, Card.new(:Hearts, 10)).
                              add(:n, Card.new(:Hearts, 8)).
                              add(:e, Card.new(:Hearts, 2))
    cda.update_tags(ccards)
    gmodel = cda.generate_domain_model(13)
    assert(gmodel[:s].include?(Card.new(:Hearts, :A)) ,"fail")
    assert(!gmodel[:e].include?(Card.new(:Hearts, :A)),"fail")
    assert(!gmodel[:w].include?(Card.new(:Hearts, :A)),"fail")
    
  end
  
  def test_generate_model_mutual_ex
    cda = Cda.new(:n)
    gmodel = cda.generate_domain_model(13)
    assert(gmodel[:s].all?{|c| !gmodel[:e].include?(c) && !gmodel[:w].include?(c)}, "Failure message.")
  end
  
  def test_copy_gd
    cda = Cda.new(:n)
    ccards = Currentcard.new.add(:s, Card.new(:Hearts, :K)).
                              add(:w, Card.new(:Hearts, 10)).
                              add(:n, Card.new(:Hearts, 8)).
                              add(:e, Card.new(:Hearts, 2))
    cda.update_tags(ccards)
    gmodel = cda.generate_domain_model(13)
    
    gclone = cda.copy_gd gmodel
    gclone[:s].delete Card.new(:Hearts, :A)
    
    assert(gmodel[:s].include?(Card.new(:Hearts, :A)) ,"fail")
    assert_equal(false, gclone[:s].include?(Card.new(:Hearts, :A)))
  end
  
  
  def test_score_value
    cda = Cda.new(:n)
    assert_equal([Card.from_id(2),5], cda.score_value(:n, [[Card.from_id(1), 2], [Card.from_id(2),5], [Card.from_id(4),1]]))
    assert_equal([Card.from_id(4),1], cda.score_value(:w, [[Card.from_id(1), 2], [Card.from_id(2),5], [Card.from_id(4),1]]))
    
  end
  
  def test_move_score
    cda = Cda.new(:n)
    rs = Roundscore.new
    gmodel = {:n=> [Card.new(:Hearts, :A), Card.new(:Hearts, 4)],
              :e=> [Card.new(:Hearts, :K), Card.new(:Clubs, 4)],
              :s=> [Card.new(:Hearts, :J), Card.new(:Clubs, 5)],
              :w=> [Card.new(:Hearts, :Q), Card.new(:Clubs, 2)]}
    

   
    assert_equal([Card.new(:Hearts, :A),0.2], cda.move_score(:n,rs, gmodel, 7)
)
   
  end

end
