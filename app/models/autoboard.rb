class Autoboard
  attr_reader :players, :scorecard, :user

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
    
    @players.each do |k, v|
      puts "cards for #{v.name}"
      v.cards.each{|card| puts card }
    end
  end
   
  def initialize
  	@players = {  :w => Paranoid.new("paranoid_w", :w), 
  	              :n => Moose.new("moose_n", :n), 
  	              :e => Paranoid.new("paranoid_e", :e),  
  	              :s => Moose.new("moose_s", :s)}
  	
    @scorecard = Scorecard.new
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
    puts "called tell_end_hand"
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

  def disp_result
    res = {}
    @players.each do |k, v|
      res[v.name] = @scorecard.current_round[k]
    end
    @game_result << res
  end
  def robot_move(dir)
    if @scorecard.current_round && @scorecard.current_round.complete_round?
      
      disp_result
    else
      if waiting_on == dir
        @players[dir].cards.map{|c| puts c } 
        [:n, :e, :s, :w].map{|k| puts "#{k} has #{@players[k].cards.length} cards left." }
        
          update_waiting_on :none
          card = players[dir].get_card(@scorecard.current_round)
          update_waiting_on dir
          move(dir, card)           
          robot_move(waiting_on)
      end
    end
  end
  
  def start(n)
    @game_result = []
    n.times do
      new_deal
      @players.values.each { |p|  p.get_called_points }
      @scorecard.add_new(Roundscore.new)
      robot_move(waiting_on)
    end
  
    @totals = {}
    @players.values.each{|p| @totals[p.name] =0 }
    
    @game_result.each do |res| 
      puts "game #{@game_result.index(res)}"
      res.each do |k , v| 
        @totals[k] +=v
        puts "#{k} won #{v} hands"
      end
    end
    
    @totals.each do |k, v|
      puts "total score for #{k} is #{v}"
      puts "avg score for #{k} is #{v/n.to_f}"
    end
  end
  
  
  def move(dir, card)
    puts ".....starting move......."
    puts "#{dir} has cards"
    @players[dir].cards.map{|c| puts c } 
    [:n, :e, :s, :w].map{|k| puts "#{k} has #{@players[k].cards.length} cards left." }

    puts "#{dir} played card #{card}"
    puts "current_cards is #{current_cards} "

    if current_cards.moves_left.zero?
      tell_end_hand(current_cards)
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