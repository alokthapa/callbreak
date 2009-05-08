#the card domain analyzer....

class Cda

  attr_reader :dir
  
  def initialize(dir)
    @dir = dir
    @ds = {}

    (0..51).each do |id|
      @ds[id] = directions
    end
  end

  def next_player(dir)
    directions[(directions.index(dir) +1)%4]
  end
  
  def directions
    [:n, :s, :w, :e]
  end
  
  def others
    [:n, :s, :w, :e] - [@dir] 
  end
  
  def score_value(dir, scores)
    #tie breaking using heuristics rule to be added
    scorevalues = scores.map{|score| score[1]}
    scores.rassoc( (dir == @dir)? scorevalues.max : scorevalues.min)
  end
  
  def max_from_sample(sr)
    #tie breaking using heuristics rule to be added
    res = {}
    sr.each do |val|
      if res[val[0]]
        res[val[0]] += val[1]
      else
        res[val[0]] = val[1]
      end
    end
  res.invert[res.values.max]
  end
  
  def get_dir_hash(rs, length)
    dir_hash = {:n => length, :s => length, :w => length, :e => length}
  
    unless rs.current_cards.moves_left.zero?
      rs.current_cards.get_dirs.each{|n| dir_hash[n] -= 1}
    end
    dir_hash
    
  end
  
  def calc_level(length)
    if length < 5
      4
    else
      2
    end
  end
  
  def monte_carlo(rs, length)
    sampled_results= []
    arr = []
    
    2.times do |n|
      arr[n] = Thread.new {
        puts "monte_carlo sampling no #{n}"
        gmodel = nil
        rsclone = rs.clone
        begin
          gmodel = generate_domain_model(get_dir_hash(rsclone, length))
        rescue
          puts " ok lengths do not match for gmodel!  "
        end
        t = Time.now
        Thread.current["res"] = move_score(@dir, rsclone, gmodel, 4*calc_level(length)  )
        t2  = Time.now - t
        puts "the operation took #{t2} seconds"
        }
    end
    
    arr.each do |t| 
      t.join
      sampled_results << t["res"]
    end
    
    max_from_sample sampled_results
  end
  
  def cda_score(dir, rs)
    rs.heuristic_score(dir)
 #   others_score = 0
 #   others.each{|d| others_score += rs.get_score[d]}
 #   rs.get_score[@dir] - others_score
  end
  
  def move_score(dir, rs, gd, level)
    pcards = rs.current_cards.moves_left.zero? ? [] : rs.current_cards.get_cards
  #  puts "starting move_score for #{dir} at level #{level}"
    
    valids = Rules.valid_moves(gd[dir],pcards)
 #   puts "played cards are "
 #   pcards.each{|v| puts "#{v}"}
 #   
 #   puts "valid moves are "
 #   valids.each{|v| puts "#{v}"}
 #
    scores = valids.map do |vcard|
      rclone = rs.clone
      gdclone = copy_gd gd
      
      gdclone[dir].delete vcard
      next_dir= rclone.add_card(dir, vcard)
      if level == 1 || rclone.complete_round?
        scr =  cda_score(dir, rclone)
 #       puts "returning cda_score #{scr}"
        [vcard, scr]
      else
        if gdclone[next_dir].empty?
          scr =  cda_score(dir, rclone)
    #      puts "returning cda_score #{scr}"
          [vcard, scr]
        else
          scc = move_score(next_dir, rclone, gdclone, level-1)            
          if scc == nil
            puts "scc is nil, sth is wrong here"
            puts "next_dir is #{next_dir}"
            puts "rclone is #{rclone}"
            puts "gdclone is #{gdclone}"
            puts "level is #{level-1}"
            puts "vcard is #{vcard}"
          end
 #         unless scc[1]
 #           puts "scc[1] is nil "
 #           puts "scc is #{scc}"
 #         end
          [vcard, scc[1]]
        end
      end
    end
    score_value(dir, scores.compact)
  end
  
  def copy_gd(gd)
    cl = {}
    gd.each_pair{|k,v| cl[k] = v.clone}
    cl
  end
  
  def get_tags(card)
    @ds[card.id]
  end
  
  def remove_tags(tag, cards)
    cards.each{|card| remove_tag(tag, card)}
  end
  
  def remove_tag(tag, card)
    @ds[card.id].delete(tag)
  end
  
  def tag_played_ccards(ccards)
    ccards.get_dirs.each{|d| tag_played_card(d, ccards.card_for(d))} 
  end
  
  def get_cards_till(card, cards)
    cards[0..cards.index(card)]
  end


# Three Rules
# 1. if card.suit not_equal first.suit, no cards of suit first.suit
# 2. if card, first, win of same suit, win> card, no cards greater than win
# 3. if first not spades, win is spades and card not first.suit, no spades greater than win
   
  def update_tags(ccards)
    tag_played_ccards(ccards)
    if ccards.count > 0
      fcard = ccards.card_for(ccards.get_dirs.first)
      
      ccards.get_dirs.each do |dir|
        card = ccards.card_for(dir)
        unless card.same_suit?(fcard)
          remove_tags(dir, all_cards_of_suit(fcard.suit))
        end
        
        win = get_current_winner(card, ccards)
        
        if(card.same_suit?(fcard) && card.same_suit?(win) && win.higher_order_than(card))
            remove_tags(dir, cards_higher_than(win))
        end
        
        if(!fcard.of_suit?(Rules.WinSuit) && win != card && win.of_suit?(Rules.WinSuit) && !card.same_suit?(fcard))
          remove_tags(dir, cards_higher_than(win))
        end
      end
    end
  end
  
  def get_current_winner(card, ccards)
    Rules.beats_all(get_cards_till(card, ccards.get_cards))
  end
  
  def tag_player_card(card)
    @ds[card.id] = [@dir]
  end
  
  def tag_player_cards(cards)
    cards.each{|c| tag_player_card c}
  end
  
  def tag_played_card(dir, card)
    @ds[card.id] = [:played, dir]
  end
  
  
  def make_cards_from_pairs(pairs)
    pairs.map{|pair| Card.from_id(pair[0])}
  end
    
  def only_for(dir)
    make_cards_from_pairs @ds.select{|k, v| v == [dir]}
  end
   
  def combination(cards, r, without=[])
    cards.select{|c| !without.include?(c)}.sort_by{rand}[0...r]
  end
  
  def maybe(dir)
    make_cards_from_pairs @ds.select{|k,v| v.include?(dir) && !v.include?(:played)}
  end
  
  def generate_domain_model(dir_hash)
    ans = {}
    used = []
    rand_others = others.sort_by{|d| maybe(d).length}
    rand_others.each do |d|
      cards = only_for(d)
      if dir_hash[d] > cards.length
        need_more = dir_hash[d] - cards.length
        cards += combination(maybe(d), need_more, used)
      end
      ans[d] = cards
      cards.each{|c| used << c }  
    end
    ans[@dir] = only_for(@dir)
 #   dir_hash.keys.each{|k| raise if ans[k].length != dir_hash[k]}
    ans
  end
  
  
  #refactor later to utilities
  def cards_smaller_than(card)
    (Card.values.index(card.value)+1..Card.values.length-1).map{ |id| Card.new(card.suit, Card.values[id]) }
  end
  
  def cards_higher_than(card)
    cards = (0..Card.values.index(card.value)).map{ |id| Card.new(card.suit, Card.values[id]) }
    cards.delete(card)
    cards
  end
  
  def all_cards_of_suit(suit)
    Card.values.map{|value| Card.new(suit, value)}
  end
  
  
 end