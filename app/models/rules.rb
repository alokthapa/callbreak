
class Rules
  
  def Rules.WinSuit
    :Spades
  end
  
  def Rules.beats?(a, b, fst=nil)
    true if Rules.beats(a, b, fst) == a
    false
  end
  
  def Rules.beats(a, b, fst=nil)
    if a.same_suit? b 
      if a.higher_order_than b 
        a
      else
        b
      end
    elsif a.of_suit? Rules.WinSuit 
       a
    elsif b.of_suit? Rules.WinSuit 
      b
    elsif a.same_suit? fst  
      a
    elsif b.same_suit? fst  
      b
    end
  end
  
  def Rules.beats_all?(card, cards)
    card == Rules.beats_all(cards+[card])
  end
  
  def Rules.beats_all(cards)
      nil if cards.empty?
      fst = cards.first
      cards.inject(fst){|result, element| Rules.beats(result, element, fst)}
  end
  
  def Rules.valid_moves(cards, pcards)
     if pcards.empty?
       cards
     elsif !Card.cards_of_suit(pcards, Rules.WinSuit).empty?
      if !Card.cards_of_suit(cards, pcards.first.suit).empty?
        if pcards.first.suit == Rules.WinSuit
          Rules.valid_suit_moves(pcards, cards)
        else
          Card.cards_of_suit(cards, pcards.first.suit)
        end
      else
        cards
      end
     elsif !valid_suit_moves(pcards, cards).empty?
      valid_suit_moves(pcards, cards)
     elsif !Card.cards_of_suit(cards, Rules.WinSuit).empty?
       Card.cards_of_suit(cards, Rules.WinSuit)
     else
       cards
     end
   end
 
  private
  def Rules.valid_suit_moves(pcards, cards)
    card = pcards.select { |card| card.of_suit?(pcards.first.suit) }.sort.first
    result = []
    Card.cards_of_suit(cards, card.suit).each{|c| result << c if c.higher_order_than(card)  }
    if (result.length > 0)
      result
    else
      Card.cards_of_suit(cards, card.suit)
    end
   end
end