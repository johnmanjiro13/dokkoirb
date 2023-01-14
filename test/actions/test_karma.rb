# frozen_string_literal: true

require 'minitest/autorun'
require 'mocha/minitest'
require 'firebase'
require 'actions/karma'

class TestKarma < Minitest::Test
  def setup
    ENV['FIREBASE_RTDB_URI'] = 'https://test.com/'
    ENV['FIREBASE_PRIVATE_KEY_PATH'] = 'test/fixtures/firebase_private_key.json'
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
      @klass = Struct.new(:body)
    end

    def get(path)
      regexp = %r{^karmas/name/(.+)$}
      match = regexp.match(path)
      raise Minitest::Assertion, "path #{path} does not match" if match.length != 2

      @klass.new(@db[match[1]])
    end

    def set(path, value)
      regexp = %r{^karmas/name/(.+)$}
      match = regexp.match(path)
      raise Minitest::Assertion, "path #{path} does not match" if match.length != 2

      @db[match[1]] = value
    end
  end
end
