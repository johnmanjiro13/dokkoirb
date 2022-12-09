# frozen_string_literal: true

require 'discordrb'

module Actions
  module Select
    extend Discordrb::EventContainer

    SELECT_REGEXP = /^dokkoi\s+select\s+(.+)/
    message(with_text: SELECT_REGEXP) do |event|
      options_str = SELECT_REGEXP.match(event.content)[1]
      options = options_str.gsub(/[.!?]/, '').split(/[,\s]/)
      event.respond options.sample
    end
  end
end
