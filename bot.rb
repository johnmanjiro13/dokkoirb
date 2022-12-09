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

bot.run(:background)
