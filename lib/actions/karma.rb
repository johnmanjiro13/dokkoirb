# frozen_string_literal: true

require 'discordrb'
require 'firebase'

module Actions
  module Karma
    extend Discordrb::EventContainer

    @last_name = ''
    KARMA_REGEXP = /^([\s\w'@.\-:\u3040-\u30FF\uFF60\u4E00-\u9FA0]*)(\+\+|--)$/
    message(with_text: KARMA_REGEXP) do |event|
      name = KARMA_REGEXP.match(event.content)[1]
      action = KARMA_REGEXP.match(event.content)[2]
      event.respond response(name, action)
    end

    module_function

    def response(name, action)
      return 'The last user is not yet registered' if name == '' && @last_name == ''

      target = get_target(name)
      karma = get_karma(target, action)
      text(target, karma)
    end

    def get_target(name)
      return @last_name if name == ''

      @last_name = name
      name
    end

    def get_karma(target, action)
      saved_karma = firebase.get("karmas/name/#{target}")
      karma = saved_karma.body.nil? ? 0 : saved_karma.body.to_i
      karma = action == '++' ? karma + 1 : karma - 1
      firebase.set("karmas/name/#{target}", karma)
      karma
    end

    def text(target, karma)
      if [1, -1].include?(karma)
        "#{target} has #{karma} point"
      else
        "#{target} has #{karma} points"
      end
    end

    def firebase
      @firebase ||= begin
        base_uri = ENV.fetch('FIREBASE_RTDB_URI')
        private_key_json_string = File.read(ENV.fetch('FIREBASE_PRIVATE_KEY_PATH'))
        Firebase::Client.new(base_uri, private_key_json_string)
      end
    end
  end
end
