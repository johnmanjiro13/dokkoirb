# frozen_string_literal: true

require 'discordrb'
require 'sinatra'

# http server for health checking
get '/ping' do
  'pong'
end

# discord bot
bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN']

bot.message(with_text: /^dokkoi\s+help/) do |event|
  content = '```
dokkoi help - Displays all of the help commands that this bot knows about.
dokkoi echo <text> - Reply back with <text>.
dokkoi select <element1>,<element2>,... - Choose one of the elements in your list randomly.
```'
  event.respond content
end

ECHO_REGEXP = /^dokkoi\s+echo\s+(.+)/
bot.message(with_text: ECHO_REGEXP) do |event|
  content = ECHO_REGEXP.match(event.content)[1]
  event.respond content
end

SELECT_REGEXP = /^dokkoi\s+select\s+(.+)/
bot.message(with_text: SELECT_REGEXP) do |event|
  options_str = SELECT_REGEXP.match(event.content)[1]
  options = options_str.gsub(/[.!?]/, '').split(/[,\s]/)
  event.respond options.sample
end

bot.run(true)
