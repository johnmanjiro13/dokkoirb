# frozen_string_literal: true

require 'minitest/autorun'
require 'actions/select'

class TestSelect < Minitest::Test
  def setup
    @container = Actions::Select
  end

  def test_select
    options_str = 'john,bob,mary'
    options = %w[john bob mary]
    got = @container.select(options_str)

    assert_equal true, options.include?(got)
  end
end
