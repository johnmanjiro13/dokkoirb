# frozen_string_literal: true

require 'discordrb'

module Actions
  module Echo
    extend Discordrb::EventContainer

    ECHO_REGEXP = /^dokkoi\s+echo\s+(.+)/
    message(with_text: ECHO_REGEXP) do |event|
      content = ECHO_REGEXP.match(event.content)[1]
      event.respond content
    end
  end
end
