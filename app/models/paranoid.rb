require "player"
class Paranoid < Player

  
  def heuristics_score(card)
    (13 - Card.values.index(card.value) ) + (card.of_suit?(:Spades) ? 13:0)
  end
  
  def initialize(name, dir)
    @cards = Array.new
    @name = name
    @dir = dir
    @cda = Cda.new(dir)
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

 def get_card(rs)
   ccards = rs.current_cards
   register_to_cda ccards
   @cards.each{|card| puts  "user card =>  #{card}"}
    @cda.only_for(@dir).each{|card| puts  "only for dir #{card}"}
    valids = Rules.valid_moves(@cards, ccards.get_cards)
    valids.each{ |card| puts "valid move card #{card}" }
    
    if valids.any?{|card| Rules.beats_all?(card, ccards.get_cards)}
      get_min_heuristics valids if ccards.moves_left == 1
       @cda.monte_carlo(rs, rs.hands_left-1)
    else
      get_min_heuristics valids
    end
 end
 
 def get_called_points
   @cards.each{|card| @cda.tag_player_card card}
    normalized_random_result(number_ace_cards(@cards) + extra_winsuit(@cards) + highcard_combo(@cards))
 end
  
  def normalized_random_result(num)
   #TODO need better algorithm
  norm =  [(num -1) > 0 ? (num - 1) :1 ,num, num, num, num,  num+1, num+1,num+1, num+1,num+2 ].sort_by{rand}.first
  norm > 0 ? norm : 1
  end
end