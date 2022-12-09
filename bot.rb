# frozen_string_literal: true

require 'discordrb'
require 'sinatra'

get '/ping' do
  'pong'
end

bot = Discordrb::Bot.new token: ENV['DISCORD_TOKEN']

bot.message(with_text: 'Ping!') do |event|
  event.respond 'Pong!'
end

ECHO_REGEXP = /^dokkoi\s+echo\s+(.+)/
bot.message(with_text: ECHO_REGEXP) do |event|
  content = ECHO_REGEXP.match(event.content)[1]
  event.respond content
end

bot.run(:background)
