require "test_helper"

class TestAppModelsPlayer < Test::Unit::TestCase

  def test_initialize
    player = Player.new("alok")
    assert_equal("alok", player.name)
    assert_equal([], player.cards)
  end
  
  def test_need_redeal
    player = Player.new("alok")
    player.receive_card(Card.new(:Hearts, :A))
    player.receive_card(Card.new(:Spades, 2))
    assert_equal(nil,player.need_redeal?)

    player = Player.new("alok")
    player.receive_card(Card.new(:Hearts, 9))
    player.receive_card(Card.new(:Spades, 2))
    assert_equal(true,player.need_redeal?)

    player = Player.new("alok")
    player.receive_card(Card.new(:Hearts, 9))
    player.receive_card(Card.new(:Clubs, 2))
    assert_equal(true,player.need_redeal?)
    
  end
  
end