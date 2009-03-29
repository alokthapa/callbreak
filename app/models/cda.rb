#the card domain analyzer....
class Cda

  attr_reader :dir, :ds
  def directions
    [:n, :s, :w, :e]
  end
  
  def others
    [:n, :s, :w, :e] - [@dir] 
  end
  
  def initialize(dir)
    @dir = dir
    @ds = {}

    (0..51).each do |id|
      @ds[id] = directions
    end
  end
  
  
  def add_player(card)
    @ds[card.id] = [@dir]
  end
  
  def add_played(dir, card)
    @ds[card.id] = [:played, dir]
  end
  
  def remove_dir(dir, card)
    @ds[card.id].delete(dir)
  end
  
  #refactor later to utilities
  def cards_smaller_than(card)
    (Card.values.index(card.value)+1..Card.values.length-1).map{ |id| Card.new(card.suit, Card.values[id]) }
  end
  
  def all_cards_of_suit(suit)
    Card.values.map{|value| Card.new(suit, value)}
  end
    
  
 end