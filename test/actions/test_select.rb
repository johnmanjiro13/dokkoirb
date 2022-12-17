# frozen_string_literal: true

require 'minitest/autorun'
require 'actions/select'

class TestSelect < Minitest::Test
  def setup
    @cmd = Actions::Select
  end

  def test_select
    options_str = 'john,bob,mary'
    options = %w[john bob mary]
    got = @cmd.select(options_str)

    assert_equal true, options.include?(got)
  end
end
