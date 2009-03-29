require "test_helper"
class TestParaniod < Test::Unit::TestCase

  def test_initialize
    player = Paranoid.new("alok")
    assert_equal("alok", player.name)
    assert_equal([], player.cards)
  end
end