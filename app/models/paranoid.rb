require "player"
class Paranoid < Player

  def initialize(name)
    @cards = Array.new
    @name = name
  end

  def register_move(dir, card)
  end

  def register_end_hand(ccards)
  end

 def get_card(ccards)
    Rules.valid_moves(@cards, ccards.get_cards).sort_by{rand}.pop
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