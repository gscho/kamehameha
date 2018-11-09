require "test_helper"

class KamehamehaTest < Minitest::Test
  def test_that_it_has_a_version_number
    refute_nil ::Kamehameha::VERSION
  end

  def test_it_does_something_useful
    ::Kamehameha::CLI.new.exec('.')
  end
end
