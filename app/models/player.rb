require "cardutility"

class Player
  
  include Cardutility
  include Enumerable
  
  attr_reader :name
  attr_accessor :cards

  def initialize(name)
    @cards = Array.new
    @name = name
  end
  
  def cards_sorted
    @cards.sort
  end
    
  def register_move(dir, card)
  end

  def register_end_hand(ccards)
  end
    
  def full_hand?
    @cards.length == 13
  end
  
  def empty_cards?
    @cards.length.zero?
  end
  
  def get_called_points 
  end 
  
  def receive_card(card)
    @cards << card
  end
  
  def get_card(ccards)
  end
  
  def need_redeal?   
    true unless @cards.any?{ |card| card.of_suit?(Rules.WinSuit)} &&
                @cards.any?{ |card| card.higher_order_than(Card.new(card.suit,10))}
  end
  
  def empty_cards
    @cards = []
  end

  def ==(other)
    @name == other.name
  end
end