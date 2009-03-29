require "test/unit"
require "test_helper"

require "card"
require "currentcards"
require "player"
require "paranoid"

class TestParaniod < Test::Unit::TestCase

  def test_initialize
    player = Paranoid.new("alok")
    assert_equal("alok", player.name)
    assert_equal([], player.cards)
  end
end