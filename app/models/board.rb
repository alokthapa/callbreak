class Board
  attr_reader :players, :scorecard, :user

  def user
    @players[:s]
  end
  
  def others
    @players.values - [user]
  end
  
  def player_names
    @players.values.collect{ |p| p.name}
  end
  
  def new_deal
    deck = Deck.new
    @players.values.each{|p| p.empty_cards }
    @players.values.each do |p|
      p.receive_card(deck.get_card) until p.full_hand?
    end
    new_deal if @players.values.any?{|p| p.need_redeal?}
    @waiting_on = directions[@scorecard.rounds%4]
  end
   
  def initialize(playername)
    raise "Invalid name, just use simple words" unless  playername =~ /\w/ 
  	@players = {  :w => Moose.new("Bob", :w), 
  	              :n => Moose.new("Rob", :n), 
  	              :e => Moose.new("John", :e),  
  	              :s => Player.new(playername, :s)}
    @scorecard = Scorecard.new
  end

  def setup_other_tricks
    @scorecard.setup_round(others.map{|it| [@players.invert[it], it.get_called_points] } )
  end

  def setup_user_tricks(tricks)
    @scorecard.setup_user_tricks(:s, tricks)
  end
  
  def update_waiting_on(dir)
    @waiting_on = dir
  end
  
  def waiting_on
    @waiting_on
  end
  
  def current_cards
    @scorecard.current_cards
  end
  
  def last_hand
    @scorecard.last_hand
  end
  
  def directions
    [:n,:e,:s,:w]
  end
  
  def next_player(dir)
    directions[(directions.index(dir) +1)%4]
  end
  
  def tell_end_hand(ccards)
    @players.values.each { |p|  p.register_end_hand(ccards) }
  end

  def tell(dir, card)
    @players.values.each { |p|  p.register_move(dir, card) }
  end
  
  def calculate_win_diff
    scores = Hash.new
    directions.each do  |d|
      scores[d] = @scorecard.get_scorecard(d)
    end
    scores = scores.sort{ |a, b| a[1] <=> b[1]}
    scores.last[1] - scores[-2][1]
  end
  
  def calculate_winner
    scores = Hash.new
    directions.each do  |d|
      scores[d] = @scorecard.get_scorecard(d)
    end
    scores.sort{ |a, b| a[1] <=> b[1]}.last[0]
  end
  
  
  def robot_move(dir)
      if waiting_on == dir
        @players[dir].cards.map{|c| puts c } 
          update_waiting_on :none
          card = players[dir].get_card(@scorecard.current_round)
          update_waiting_on dir
          move(dir, card)           
      end
  end
  
  def move(dir, card)
    @players[dir].cards.map{|c| puts c } 

    if current_cards.moves_left.zero?
      tell_end_hand(current_cards)
    end

    #verify turn 
    if waiting_on == dir
      update_waiting_on :none
      update_waiting_on(@scorecard.current_round.add_card(dir, card))
      @players[dir].cards.delete(card)
    end
  end
  
  def names_only
    nonly = {}
    @players.each{ |key,value| nonly[key] = value.name }
    nonly
  end
  
end
