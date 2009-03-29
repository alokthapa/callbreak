class RoundScore
  attr_reader :hash, :called, :hands
  alias org_to_json to_json
  
  def initialize
    @hash = {:n => 0,:e => 0,:s => 0, :w => 0}
    @called  = {:n => 0,:e => 0,:s => 0, :w => 0}
    @hands = [CurrentCards.new]
  end
  
  def complete_round?
    13 == @hash.values.inject{|sum, n| sum + n }
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
  
  
  def get_score_for(name)
    if @called[name] > @hash[name]
      -1 * @called[name]
    else
      @called[name] + (@hash[name] - @called[name] ) * 0.1
    end
  end
  
  def to_json
    { "called" => @called.to_json, "actual" => @hash.to_json}.to_json
  end
  
end