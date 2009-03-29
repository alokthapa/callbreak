
class CurrentCards
  alias org_to_json to_json
  
  def initialize()
    @ccards = []
  end
  
  def card_for(dir)
    if (@ccards.assoc(dir))
      @ccards.assoc(dir)[1]
    end
    
  end
  
  def add(dir, card)
    @ccards << [dir, card]
    self
  end
  
  def moves_left
    4 - @ccards.length
  end
  
  def count
    @ccards.length
  end
  
  def get_cards
    @ccards.map{|pair| pair[1]}
  end
  
  def calculate_hand_winner
    @ccards.rassoc(Rules.beats_all(get_cards)).first
  end
  
  def to_json
    @ccards.map{ |pair| {"  dir:  " => pair[0], "  card:  " => pair[1].to_json }}.to_json
  end
  
  def to_s
    @ccards.map{ |pair| {:dir => pair[0], :card => pair[1].to_s}}.to_s
  end
  
end
