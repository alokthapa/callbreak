#the card domain analyzer....

class Cda

  attr_reader :dir
  
  def initialize(dir)
    @dir = dir
    @ds = {}

    (0..51).each do |id|
      @ds[id] = directions
    end
  end
  
  def directions
    [:n, :s, :w, :e]
  end
  
  def others
    [:n, :s, :w, :e] - [@dir] 
  end
  
  def get_tags(card)
    @ds[card.id]
  end
  
  def remove_tags(tag, cards)
    cards.each{|card| remove_tag(tag, card)}
  end
  
  def remove_tag(tag, card)
    @ds[card.id].delete(tag)
  end
  
  def tag_played_ccards(ccards)
    ccards.get_dirs.each{|d| tag_played_card(d, ccards.card_for(d))} 
  end
  
  def get_cards_till(card, cards)
    cards[0..cards.index(card)]
  end


# Three Rules
# 1. if card.suit not_equal first.suit, no cards of suit first.suit
# 2. if card, first, win of same suit, win> card, no cards greater than win
# 3. if first not spades, win is spades and card not first.suit, no spades greater than win
   
  def update_tags(ccards)
    tag_played_ccards(ccards)
    if ccards.count > 0
      fcard = ccards.card_for(ccards.get_dirs.first)
      
      ccards.get_dirs.each do |dir|
        card = ccards.card_for(dir)
        unless card.same_suit?(fcard)
          remove_tags(dir, all_cards_of_suit(fcard.suit))
        end
        
        win = get_current_winner(card, ccards)
        
        if(card.same_suit?(fcard) && card.same_suit?(win) && win.higher_order_than(card))
            remove_tags(dir, cards_higher_than(win))
        end
        
        if(!fcard.of_suit?(Rules.WinSuit) && win.of_suit?(Rules.WinSuit) && !card.same_suit?(fcard))
          remove_tags(dir, cards_higher_than(win))
        end
      end
    end
  end
  
  def get_current_winner(card, ccards)
    Rules.beats_all(get_cards_till(card, ccards.get_cards))
  end
  
  def tag_player_card(card)
    @ds[card.id] = [@dir]
  end
  
  def tag_player_cards(cards)
    cards.each{|c| tag_player_card c}
  end
  
  def tag_played_card(dir, card)
    @ds[card.id] = [:played, dir]
  end
  
  
  #refactor later to utilities
  def cards_smaller_than(card)
    (Card.values.index(card.value)+1..Card.values.length-1).map{ |id| Card.new(card.suit, Card.values[id]) }
  end
  
  def cards_higher_than(card)
    cards = (0..Card.values.index(card.value)).map{ |id| Card.new(card.suit, Card.values[id]) }
    cards.delete(card)
    cards
  end
  
  def all_cards_of_suit(suit)
    Card.values.map{|value| Card.new(suit, value)}
  end
  
  def make_cards_from_pairs(pairs)
    pairs.map{|pair| Card.from_id(pair[0])}
  end
  
  def only_for(dir)
    make_cards_from_pairs @ds.select{|k, v| v == [dir]}
  end
  
  def combination(cards, r, without=[])
    cards.select{|c| !without.include?(c)}.sort_by{rand}[0...r]
  end
  
  def maybe(dir)
    make_cards_from_pairs @ds.select{|k,v| v.include?(dir) && !v.include?(:played)}
  end
  
  def generate_domain_model(length)
    ans = {}
    used = []
    rand_others = others.sort_by{rand}
    rand_others.each do |d|
      cards = only_for(d)
      if length > cards.length
        need_more = length - cards.length
        cards += combination(maybe(d), need_more, used)
      end
      ans[d] = cards
      cards.each{|c| used << c }  
    end
    ans
  end
 end