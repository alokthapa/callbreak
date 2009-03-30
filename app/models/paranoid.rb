require "player"
class Paranoid < Player


  def heuristics_score(card)
    (13 - Card.values.index(card.value) ) + (card.of_suit?(:Spades) ? 13:0)
  end
  
  def initialize(name)
    @cards = Array.new
    @name = name
  end

  def register_move(dir, card)
  end

  def register_end_hand(ccards)
  end
  
  def get_min_heuristics(cards)
    cards.min{|a,b| heuristics_score(a) <=> heuristics_score(b)}
  end

 def get_card(ccards)
    valids = Rules.valid_moves(@cards, ccards.get_cards)
    valids.each{ |card| puts "valid move card #{card}" }
    
    if valids.any?{|card| Rules.beats_all?(card, ccards.get_cards)}
      get_min_heuristics valids if ccards.moves_left == 1
      valids.sort_by{rand}.pop
    else
      get_min_heuristics valids
    end
 end
 
 def get_called_points  
    normalized_random_result(number_ace_cards(@cards) + extra_winsuit(@cards) + highcard_combo(@cards))
 end
  
  def normalized_random_result(num)
   #TODO need better algorithm
  norm =  [(num -1) > 0 ? (num - 1) :1 ,num, num, num, num,  num+1, num+1,num+1, num+1,num+2 ].sort_by{rand}.first
  norm > 0 ? norm : 1
  end
end