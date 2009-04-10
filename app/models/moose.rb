require "paranoid"
class Moose < Player

  
  def initialize(name, dir)
    @cards = Array.new
    @name = name
    @dir = dir
  end

 def get_card(rs)
   ccards = rs.current_cards
   pcards = ccards.moves_left.zero? ? [] : ccards.get_cards

   valids = Rules.valid_moves(@cards, pcards )
   valids.each{ |card| puts "valid move card #{card}" }
   puts "number of valids is #{valids.length}"
   
   puts "playing a random card"
   valids.sort_by{rand}.pop
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