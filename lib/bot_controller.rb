# frozen_string_literal: true

require 'discordrb'

class BotController
  def initialize
    @bot = Discordrb::Bot.new token: ENV.fetch('DISCORD_TOKEN')

    @help_messages = []
  end

  # @see Discordrb::Commands::CommandContainer#include!
  def include!(container, msg)
    @bot.include!(container)
    @help_messages << msg
  end

  def run(background: false)
    @bot.message(with_text: /^dokkoi\s+help/) do |event|
      content = "```
dokkoi help - Displays all of the help actions that this bot knows about.
#{@help_messages.join("\n")}
```"
      event.respond content
    end
    @bot.run(background)
  end
end
