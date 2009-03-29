require "roundscore"
require "currentcards"
require "scorecard"
require "board"
require "player"
require "paranoid"
require "card"
require "deck"
require "rules"




class PlayController < ApplicationController
	before_filter :init, :except => [:about, :index, :new_game, :get_name]
	
	def index
	  redirect_to :action => "get_name"
  end
	
	def get_name
	end
	
	def about
  end
	
	def next_move
  end
  
	def new_game
	  begin 
	    @board = Board.new params[:player_name]
	    session[:board]  = @board
 	    redirect_to :action => "get_called_points"
    rescue
      flash[:notice] = "Invalid name, just use simple words"
      redirect_to :action => "get_name"
    end
  end
  
	def get_called_points
		@board.new_deal
		@board.setup_other_tricks
		@roundscore = @scorecard.current_round
	end
	
  def user_move
    card = Card.from_id(params[:id].to_i)
    @board.move(:s, card) if card
    update_page_components
  end
  
  def reset_game
    reset
	  redirect_to :action => "new_game", :player_name => @player.name
  end
  
  def update_north
    player_move(:n)
  end
  
  def update_east
    player_move(:e)
  end
  
  def update_west
    player_move(:w)
  end
  
  def update_waiting_on
    puts "update waiting on returned #{@board.waiting_on}"
    render :partial => "waiting_on"
  end
	
	def update_lasthand
	  if @board.last_hand
	    render :partial  => "lasthand", :locals => { :lcards => @board.last_hand}
    else
      render :nothing => true
    end
  end
  
	def end_game
    if :s ==  @board.calculate_winner
      user = User.new(:name => @board.user.name, :diff => @board.calculate_win_diff).save
      
      @msg = "Congratulations!! You won!!"
    else
      @msg = "Sorry you lost, better luck next time"
    end
  end
  
	def start_round
		pts = params[:called_points]
		if  valid_tricks_input pts then
  		@board.setup_user_tricks pts
      redirect_to :action => "next_move"		
	  else
	    flash[:notice] = "Called point should be between 1 and 13"
 	    redirect_to :action => "get_called_points"
	  end
	end
	
	def end_round
		redirect_to :action => "end_game" if  @scorecard.rounds == 5
	end
	
  def debug
  end
  
	private
		
	def update_page_components
 	    render :update do |page|
      page.replace_html 'lasthand', {:partial => 'lasthand' ,:locals => { :lcards => @board.last_hand}} if @board.last_hand
      page.replace_html 'score', {:partial  => "score", :locals => { :round => @scorecard.current_round } }
      page.replace_html 'player_cards', {:partial => 'player_cards' , :locals => { :cards =>  @board.user.cards_sorted } }
      page.replace_html 'north', {:partial => 'card' ,:object => @board.current_cards.card_for(:n), :locals => {:valid => false}}
      page.replace_html 'east', {:partial => 'card' ,:object => @board.current_cards.card_for(:e), :locals => {:valid => false}}
      page.replace_html 'west', {:partial => 'card' ,:object => @board.current_cards.card_for(:w),  :locals => {:valid => false}}
      page.replace_html 'south', {:partial => 'card' ,:object => @board.current_cards.card_for(:s),  :locals => {:valid => false}}
    end
  end
  
	def player_move(dir)
    @board.robot_move dir
    update_page_components
  end
  
	def valid_tricks_input(pts)
     pts && pts.to_i && (1..13) === pts.to_i
  end
  
	def reset
			session[:board] = nil
  end

	def init
	    @board = session[:board]
	    unless @board
	      redirect_to :action => "index"
	      return
      end
	    @scorecard = @board.scorecard
	    @players = @board.players.values
	    @player = @board.user
	end
end
