# frozen_string_literal: true

require 'discordrb'

module Actions
  module Select
    extend Discordrb::EventContainer

    SELECT_REGEXP = /^dokkoi\s+select\s+(.+)/
    message(with_text: SELECT_REGEXP) do |event|
      result = select(SELECT_REGEXP.match(event.content)[1])
      event.respond result
    end

    module_function

    def select(options_str)
      options = options_str.gsub(/[.!?]/, '').split(/[,\s]/)
      options.sample
    end
  end
end
