require "set"
module Cardutility
  def self.included(klass)
    klass.extend ClassMethods
  end


  def suits_without_win
    Card.suits - [Rules.WinSuit]
  end

  def highcard_combo(cards)
    suits_without_win.map{ |suit| 
        Card.cards_of_suit(cards, suit).select{ |card|  card.value == :K || 
                                                        card.value == :Q ||
                                                        card.value == :J}.length > 1 ? 1 : 0 }.inject{|sum, n| sum + n }
  end

  def extra_winsuit(cards)
    Card.cards_of_suit(cards, Rules.WinSuit).length > 3 ? 
      Card.cards_of_suit(cards, Rules.WinSuit).length - 3 : 0
  end

  def number_ace_cards(cards)
    cards.select{|card| card.value == :A}.length
  end
  
  
  
  module ClassMethods

  end
  
end
  