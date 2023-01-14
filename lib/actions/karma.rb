# frozen_string_literal: true

require 'discordrb'
require 'firebase'

module Actions
  module Karma
    extend Discordrb::EventContainer

    KARMA_REGEXP = /^([\s\w'@.\-:\u3040-\u30FF\uFF60\u4E00-\u9FA0]*)(\+\+|--)$/
    message(with_text: KARMA_REGEXP) do |event|
      matched = KARMA_REGEXP.match(event.content)
      name = matched[1]
      action = matched[2]
      event.respond response(name, action)
    end

    module_function

    def response(name, action)
      last_user = find_last_user
      return 'The last user is not yet registered' if name == '' && last_user.nil?

      target = if name == ''
                 last_user
               else
                 firebase.set('karmas/last_user', name)
                 name
               end
      karma = get_karma(target, action)
      text(target, karma)
    end

    def find_last_user
      response = firebase.get('karmas/last_user')
      response.body.nil? ? nil : response.body
    end

    def get_karma(target, action)
      response = firebase.get("karmas/user/#{target}")
      karma = response.body.nil? ? 0 : response.body.to_i
      karma = action == '++' ? karma + 1 : karma - 1
      firebase.set("karmas/user/#{target}", karma)
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
