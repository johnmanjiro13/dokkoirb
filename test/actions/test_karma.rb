# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'firebase'
require 'actions/karma'

class TestKarma < Minitest::Test
  def setup
    ENV['FIREBASE_RTDB_URI'] = 'https://test.com/'
    ENV['FIREBASE_PRIVATE_KEY_PATH'] = 'test/fixtures/firebase_key.json'
    @container = Actions::Karma
  end

  def test_karma
    Firebase::Client.stubs('new').returns(MockFirebase.new)

    assert_equal 'The last user is not yet registered', @container.response('', '++')
    assert_equal 'john has 1 point', @container.response('john', '++')
    assert_equal 'john has 2 points', @container.response('', '++')
    assert_equal 'bob has -1 point', @container.response('bob', '--')
    assert_equal 'bob has -2 points', @container.response('', '--')
    assert_equal 'charly has 1 point', @container.response('charly', '++')
    assert_equal 'charly has 0 points', @container.response('charly', '--')
  end

  class MockFirebase
    def initialize
      @db = {}
      @path_regexp = %r{^(karmas/user/(.+)|karmas/last_user)$}
    end

    def get(path)
      matched = @path_regexp.match(path)
      raise Minitest::Assertion, "path #{path} does not match" if matched.nil? || matched.length != 3

      response = Struct.new(:body)
      response.new(@db[matched[1]])
    end

    def set(path, value)
      matched = @path_regexp.match(path)
      raise Minitest::Assertion, "path #{path} does not match" if matched.nil? || matched.length != 3

      @db[matched[1]] = value
    end
  end
end
