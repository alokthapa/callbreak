require "test/unit"
require "test_helper"

require "card"
require "currentcards"
require "player"

class TestAppModelsPlayer < Test::Unit::TestCase

  def test_initialize
    player = Player.new("alok")
    assert_equal("alok", player.name)
    assert_equal([], player.cards)
  end
  
end