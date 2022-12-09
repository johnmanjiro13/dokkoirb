# frozen_string_literal: true

require 'sinatra'
require './lib/bot_controller'
require './lib/actions/echo'
require './lib/actions/select'
require './lib/actions/image'

# http server for health checking
get '/ping' do
  'pong'
end

# discord bot
bc = BotController.new
bc.include! Actions::Echo, 'dokkoi echo <text> - Reply back with <text>.'
bc.include! Actions::Select,
            'dokkoi select <element1>,<element2>,... - Choose one of the elements in your list randomly.'
bc.include! Actions::Image, 'dokkoi image <query> - Queries Google Images for <query> and returns a top result.'

# bot.join is not needed because sinatra runs in the main thread
bc.run(background: true)
