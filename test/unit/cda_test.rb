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
  
  def test_generate_model_diff_length
    cda = Cda.new(:n)
    cda.tag_player_cards((0..12).map{|id| Card.from_id(id)})
    gmodel = cda.generate_domain_model({:w => 13, :n =>13, :s => 13, :e =>12})
    assert_equal(13,gmodel[:n].length)
    assert_equal(12,gmodel[:e].length)
    assert_equal(13,gmodel[:w].length)
    assert_equal(13,gmodel[:s].length)
  end
  
  
  def test_generate_model_not_include_player_cards

    cda = Cda.new(:n)
    cda.tag_player_cards((0..12).map{|id| Card.from_id(id)})
    gmodel = cda.generate_domain_model({:w => 13, :n =>13, :s => 13, :e =>13})
    
    assert(!gmodel[:s].include?(Card.from_id(0)), "Failure message.")
    assert(!gmodel[:e].include?(Card.from_id(0)), "Failure message.")
    assert(!gmodel[:w].include?(Card.from_id(0)), "Failure message.")
  end
  
  def test_generate_model_length_eq
    cda = Cda.new(:w)
    gmodel = cda.generate_domain_model({:w => 13, :n =>13, :s => 13, :e =>13})
    assert_equal(13,gmodel[:s].length)
    assert_equal(13,gmodel[:n].length)
    assert_equal(13,gmodel[:e].length)
    
    cda.tag_player_cards(
    [ Card.new(:Hearts, 2),Card.new(:Spades, :J), Card.new(:Clubs, 10), Card.new(:Spades, 5),
      Card.new(:Spades, :K), Card.new(:Clubs, 2), Card.new(:Clubs, 8), Card.new(:Hearts, :K),
      Card.new(:Hearts, 7), Card.new(:Diamonds, 4), Card.new(:Spades, 6), Card.new(:Spades, :A),
      Card.new(:Spades, 4)])
      
    cda.update_tags(Currentcard.new.add(:n, Card.new(:Diamonds, :K)).
                              add(:e, Card.new(:Diamonds, 3)).
                              add(:s, Card.new(:Diamonds, 5)).
                              add(:w, Card.new(:Diamonds, 4)))

    cda.update_tags(Currentcard.new.add(:n, Card.new(:Diamonds, :A)).
                              add(:e, Card.new(:Diamonds, 8)).
                              add(:s, Card.new(:Diamonds, 6)).
                              add(:w, Card.new(:Spades, 4)))
                              
    cda.update_tags(Currentcard.new.add(:w, Card.new(:Clubs, 10)).
                              add(:n, Card.new(:Clubs, :J)).
                              add(:e, Card.new(:Clubs,:Q)).
                              add(:s, Card.new(:Clubs, :K)))

    
    gmodel = cda.generate_domain_model({:w => 10, :n =>10, :s => 10, :e =>10})
    
    assert_equal(10,gmodel[:s].length)
    
    assert_equal(10,cda.only_for(:w).length)
 #   assert_equal(10,gmodel[:w].length)
    assert_equal(10,gmodel[:e].length)
    assert_equal(10,gmodel[:n].length)

  end
  
  def test_generate_model_only_for
    cda = Cda.new(:n)
    ccards = Currentcard.new.add(:s, Card.new(:Hearts, :K)).
                              add(:w, Card.new(:Hearts, 10)).
                              add(:n, Card.new(:Hearts, 8)).
                              add(:e, Card.new(:Hearts, 2))
    cda.update_tags(ccards)
    gmodel = cda.generate_domain_model({:w => 13, :n =>13, :s => 13, :e =>13})
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
    gmodel = cda.generate_domain_model({:w => 13, :n =>13, :s => 13, :e =>13})
    
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
    

   
    assert_equal([Card.new(:Hearts, :A),-1], cda.move_score(:n,rs, gmodel, 7)
)
   
  end
  
  def test_max_from_sample
    sr = [[Card.from_id(1),5],[Card.from_id(2),3],[Card.from_id(5),1]]
    cda = Cda.new(:n)
    
    assert_equal(Card.from_id(1),cda.max_from_sample(sr))
  end
  
  def test_get_dir_hash
    
    rs = Roundscore.new
    rs.add_card(:n, Card.from_id(1))
    rs.add_card(:e, Card.from_id(3))
    
    cda = Cda.new(:w)
    dir_hash =cda.get_dir_hash(rs, 13)
    assert_equal(12, dir_hash[:n])
    assert_equal(12, dir_hash[:e])
    assert_equal(13, dir_hash[:s])
    assert_equal(13, dir_hash[:w])
  end
  
 # update waiting on returned n
 # Card: Clubs 10
 # Card: Spades 5
 # Card: Spades 2
 # n has 3 cards left.
 # e has 3 cards left.
 # s has 3 cards left.
 # w has 2 cards left.
 # user card =>  Card: Clubs 10
 # user card =>  Card: Spades 5
 # user card =>  Card: Spades 2
 # only for dir Card: Clubs 10
 # only for dir Card: Spades 2
 # only for dir Card: Spades 5
 # valid move card Card: Spades 5
 # valid move card Card: Spades 2
 # monte_carlo sampling no 0
 # gmodel n has 3 cards
 # gmodel s has 2 cards
 # gmodel e has 3 cards
 # gmodel w has 3 cards
 # predicted card for s is Card: Spades 7
 # predicted card for s is Card: Hearts 10
 # monte_carlo sampling no 1
 # gmodel n has 3 cards
 # gmodel s has 2 cards
 # gmodel e has 3 cards
 # gmodel w has 3 cards
 # predicted card for s is Card: Spades 10
 # predicted card for s is Card: Hearts 7
 # scc is nil, sth is wrong here
 # next_dir is n
 # Called:
 # w called 4
 # n called 2
 # s called 1
 # e called 2
 # Score:
 # w has 6
 # n has 1
 # s has 2
 # e has 2
 # Hands:
 # dirncardCard: Diamonds 2direcardCard: Diamonds KdirscardCard: Diamonds 6dirwcardCard: Diamonds A
 # dirwcardCard: Diamonds 8dirncardCard: Diamonds 4direcardCard: Diamonds 9dirscardCard: Diamonds 10
 # dirscardCard: Clubs 9dirwcardCard: Clubs AdirncardCard: Clubs 2direcardCard: Clubs 7
 # dirwcardCard: Clubs 4dirncardCard: Clubs 5direcardCard: Clubs JdirscardCard: Clubs Q
 # dirscardCard: Clubs 3dirwcardCard: Spades 4dirncardCard: Clubs 6direcardCard: Clubs K
 # dirwcardCard: Hearts AdirncardCard: Hearts QdirecardCard: Hearts 5dirscardCard: Hearts 3
 # dirwcardCard: Hearts 2dirncardCard: Hearts KdirecardCard: Hearts JdirscardCard: Hearts 6
 # dirncardCard: Diamonds 7direcardCard: Diamonds 3dirscardCard: Diamonds QdirwcardCard: Spades 3
 # dirwcardCard: Hearts 8dirncardCard: Spades KdirecardCard: Spades AdirscardCard: Hearts 9
 # direcardCard: Diamonds 5dirscardCard: Diamonds JdirwcardCard: Spades QdirncardCard: Clubs 8
 # dirwcardCard: Hearts 4dirncardCard: Spades 2direcardCard: Spades 9dirscardCard: Hearts 7
 # direcardCard: Spades 6dirscardCard: Spades 10dirwcardCard: Spades 7
 # rclone is #<Roundscore:0x24e2080>
 # gdclone is wCard: Hearts 10Card: Spades 8nCard: Clubs 10Card: Spades 5seCard: Spades J
 # level is 2
 # vcard is Card: Spades 7
 # update waiting on returned none
 # 

end
