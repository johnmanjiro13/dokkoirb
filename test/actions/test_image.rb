# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'google/apis/customsearch_v1'
require 'actions/image'

class TestImage < Minitest::Test
  def setup
    ENV['CUSTOMSEARCH_API_KEY'] = 'dummy'
    ENV['CUSTOMSEARCH_ENGINE_ID'] = 'dummy'
    @container = Actions::Image
  end

  def test_image
    item = Struct.new(:link)
    query_result = Struct.new(:items)
    result = query_result.new([item.new('https://example.com')])
    Google::Apis::CustomsearchV1::CustomSearchAPIService.any_instance.stubs(:list_cses).returns(result)

    assert_equal 'https://example.com', @container.query_image('test')
  end
end
