class AutoBoard
  attr_reader :players

  def directions
    [:n,:e,:s,:w]
  end
  
  def player_names
    @players.values.collect{ |p| p.name}
  end
  
  def initialize(gd)
    @gd = gd
    #somehow initialize values
    @roundscore = RoundScore.new
  end
  
  def update_waiting_on(dir)
    @waiting_on = dir
  end
  
  def waiting_on
    @waiting_on
  end
  
  def current_cards
    @roundscore.current_cards
  end

  def next_player(dir)
    directions[(directions.index(dir) +1)%4]
  end

  def calculate_score
    @roundscore.get_score_for(@dir)
  end
  
  def move(dir, card)
    if current_cards.moves_left.zero?
      current_round.hands << CurrentCards.new
    end
    #verify turn 
    if waiting_on == dir
      update_waiting_on :none
      #add move
      current_cards.add dir, card
      if current_cards.moves_left.zero?
        win = current_cards.calculate_hand_winner
        @roundscore.add_one(win)
        update_waiting_on win
      else
        update_waiting_on next_player(dir)
      end
      @players[dir].cards.delete(card)
    end
  end
end