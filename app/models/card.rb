require "cardutility"
class Card
  include Cardutility
  include Enumerable
  attr_reader :suit, :value, :id

  def Card.suits
    [ :Hearts,:Clubs, :Diamonds, :Spades]
  end
  
  def Card.values
    [:A,:K, :Q,:J,10,9,8,7,6,5,4,3,2]
  end

  def Card.from_id(id)
    Card.new(Card.suits[id / 13 ],Card.values[id % 13 ] ) if (0..51).include? id
  end
  
  def Card.cards_of_suit(cards, suit)
    cards.select{ |card| card.suit == suit}
  end
  
  def initialize(suit , value)
    @suit = suit
    @value = value
    @id = Card.suits.index(suit) * 13 + Card.values.index(value)
  end
    
  def <=>(other)
    @id <=> other.id
  end
  
  def ==(other)
    @id == other.id
  end
  
  def same_suit?(other)
    other.of_suit?(@suit)
  end

  def of_suit?(suit)
    @suit == suit
  end
  
  def to_s
    "Card: " + @suit.to_s + " " + @value.to_s
  end
  
  def higher_order_than(other)
      nil if other.suit != @suit
     Card.values.index(@value) < Card.values.index(other.value)
  end

end