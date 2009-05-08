class Deck

  attr_accessor :cards
 
  def initialize(shuffled = true)
    @cards = shuffled ? shuffle(build_deck) : build_deck
  end
  
  def Deck.from_cards(cards)
    d = Deck.new()
    d.cards = cards
    d
  end

  def  build_deck
    (0..51).collect{ |id| Card.from_id(id) }
  end

  def get_card
    @cards.pop
  end

  def shuffle(cards)
    cards.sort_by{rand}
  end
  
  
  
end