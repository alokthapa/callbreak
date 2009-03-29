class Scorecard
  
  attr_reader :rscores, :current_round
  def initialize
      @rscores = Array.new
  end
  
  def add_new(roundscore)
    @rscores << roundscore
  end
  
  def get_scorecard(name)
   complete_rounds.collect{ |rscore| rscore.get_score[name] }.inject(0) {|sum, val| sum += val}
  end
  
  def setup_round(called)
    add_new RoundScore.new
    called.each do |c|
      current_round.add_called_points(c[0], c[1])
    end
  end
  
  def setup_user_tricks(name, call)
    current_round.add_called_points(name, call)
  end
  
  def current_round
    @rscores.last
  end
  
  def complete_rounds
    @rscores.select{|rscore| rscore.complete_round? }
  end
  
  def rounds
    @rscores.length
  end
  
  def current_cards
    current_round.current_cards
  end
  
  def last_hand
    current_round.last_hand
  end

end