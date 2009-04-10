class Roundscore
  attr_accessor :hash, :called, :hands
  
  def initialize
    @hash = {:n => 0,:e => 0,:s => 0, :w => 0}
    @called  = {:n => 0,:e => 0,:s => 0, :w => 0}
    @hands = [Currentcard.new]
  end
  
  def clone
    r = Roundscore.new
    r.hash = @hash.clone
    r.called = @called.clone
    r.hands = @hands.map{|cc| cc.clone}
    r
  end
  
  def directions
    [:n,:e,:s,:w]
  end
  
  def next_player(dir)
    directions[(directions.index(dir) +1)%4]
  end
  
  def hands_left
    13 - total_hands
  end
  
  def complete_round?
    13 == total_hands
  end
  
  def total_hands
    @hash.values.inject{|sum, n| sum + n }
  end
  
  def [](name)
    @hash[name]
  end
  
  def add_one(user)
    if(@hash[user])
      @hash[user] += 1
    else
      add(user, 1)
    end
    self
  end
  
  def add_card(dir, card)
    if current_cards.moves_left.zero?
      @hands << Currentcard.new
    end
    current_cards.add dir, card
    if current_cards.moves_left.zero?
      win = current_cards.calculate_hand_winner
      add_one win
      win
    else
      next_player(dir)
    end
  end
  
  def current_cards
    hands.last
  end
  
  def last_hand
    hands.length > 1 ? hands[hands.length() -2] : nil
  end
  
  def add_called_points(user,called)
    @called[user] = called.to_i
    @hash[user] = 0
    self
  end
  
  def add(user, score)
    @hash[user] = score
    self
  end
  
  def get_score
    scores = {}
    [:n,:e,:s,:w].each do |dir|
      scores[dir]= get_score_for dir || 0
    end
    scores
  end
  
  def heuristic_score(dir)
    otherscores = 0
    (directions - [dir]).each{ |d| otherscores +=  @hash[d]}
    @hash[dir]- otherscores
  end
  
  def get_score_for(name)
    if @called[name] > @hash[name]
      -1 * @called[name]
    else
      @called[name] + (@hash[name] - @called[name] ) * 0.1
    end
  end
  
  def to_s
    puts "Called:" 
    @called.each{|k, v| puts "#{k} called #{v}"}
    puts "Score:" 
    @hash.each{|k, v| puts "#{k} has #{v}"}
    puts "Hands:"
    @hands.each{|ccard| puts "#{ccard}"}
  end

end