require "player"
class Paranoid < Player

  
  def heuristics_score(card)
    (13 - Card.values.index(card.value) ) + (card.of_suit?(:Spades) ? 13:0)
  end
  
  def initialize(name, dir)
    @cards = Array.new
    @name = name
    @dir = dir
  end

  def register_to_cda(ccards)
    @cda.update_tags(ccards)
  end
  
  def receive_card(card)
    @cards << card
  end
  
  def register_end_hand(ccards)
    register_to_cda ccards
  end
  
  def get_min_heuristics(cards)
    cards.min{|a,b| heuristics_score(a) <=> heuristics_score(b)}
  end

  def too_many_choices(cards)
    puts "in too many choices"
    total = []
    (Card.suits-[Rules.WinSuit]).each do |suit|
      scards = Card.cards_of_suit(cards, suit)
      total << [scards.length, suit]
    end
    min_suit = total.select{|t| t[0] >0}.sort_by{|t| t[0] }.first[1]
    
    Card.cards_of_suit(cards, min_suit).sort_by{|card| Card.values.index(card.value) }.last

  end    
  
  def choose_random(cards)
    cards.sort_by{rand}.pop
  end
  
 def get_card(rs)
   ccards = rs.current_cards
   pcards = ccards.moves_left.zero? ? [] : ccards.get_cards
   register_to_cda ccards
   valids = Rules.valid_moves(@cards, pcards )
   return valids.first if valids.length == 1
   return choose_random(valids) if rs.hands_left > 5
   
   return @cda.monte_carlo(rs, rs.hands_left)
   
   #return too_many_choices(valids) if valids.length > 5
 #   
 #  if valids.any?{|card| Rules.beats_all?(card, pcards)}
 #    return get_min_heuristics(valids) if ccards.moves_left == 1
 #    @cda.monte_carlo(rs, rs.hands_left)
 #  else
 #     if rs.hands_left > 5
 #       get_min_heuristics valids
 #     else 
 #       @cda.monte_carlo(rs, rs.hands_left)
 #     end
 #  end
 end
 
 
 def get_called_points
   @cda = Cda.new(@dir)
   
   @cards.each{|card| @cda.tag_player_card card}
    normalized_random_result(number_ace_cards(@cards) + extra_winsuit(@cards) + highcard_combo(@cards))
 end
  
  def normalized_random_result(num)
   #TODO need better algorithm
  norm =  [(num -1) > 0 ? (num - 1) : 1 ,num, num, num, num,   num+1 ].sort_by{rand}.first
  norm > 0 ? norm : 1
  end
end