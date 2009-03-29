require "test_helper"

class TestAppModelsPlayer < Test::Unit::TestCase

  def test_initialize
    player = Player.new("alok")
    assert_equal("alok", player.name)
    assert_equal([], player.cards)
  end
  
end