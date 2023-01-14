# frozen_string_literal: true

require 'sinatra'
Dir['./lib/**/*.rb'].each { |file| require file }

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
bc.include! Actions::Karma, '<name>(++|--) - Increment/Decrement score for a name'

# bot.join is not needed because sinatra runs in the main thread
bc.run(background: true)
