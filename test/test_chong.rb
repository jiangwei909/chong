require 'minitest/autorun'
require 'chong'

class ChongTest < Minitest::Test
  def test_run
    Chong.run
  end
end