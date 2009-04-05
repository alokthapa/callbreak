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
  	@players = {  :w => Paranoid.new("Bob"), 
  	              :n => Paranoid.new("Rob"), 
  	              :e => Paranoid.new("John"),  
  	              :s => Player.new(playername)}
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
      move(dir, players[dir].get_card(current_cards.moves_left.zero? ? Currentcard.new: current_cards)) if waiting_on == dir
  end
  
  
  def move(dir, card)
    puts ".....starting move......."
    puts "#{dir} has cards"
    @players[dir].cards.map{|c| puts c } 
    [:n, :e, :s, :w].map{|k| puts "#{k} has #{@players[k].cards.length} cards left." }

    puts "#{dir} played card #{card}"
    puts "current_cards is #{current_cards} "

    if current_cards.moves_left.zero?
      @scorecard.current_round.hands << Currentcard.new
    end
    #verify turn 
    if waiting_on == dir
      update_waiting_on :none
      puts "yes we were waiting on you... "

      update_waiting_on(@scorecard.current_round.add_card(dir, card))

      @players[dir].cards.delete(card)
    else
      puts "it's not your time yet chump.... "
    end
    
    puts ".....ending move......."
    puts "#{dir} played card #{card}"
    puts "current_cards is #{current_cards} "
    [:n, :e, :s, :w].map{|k| puts "#{k} has #{@players[k].cards.length} cards left." }
  end
  
  def names_only
    nonly = {}
    @players.each{ |key,value| nonly[key] = value.name }
    nonly
  end
  
end