# frozen_string_literal: true

require 'discordrb'
require 'sinatra'
require 'google/apis/customsearch_v1'

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
dokkoi image <query> - Queries Google Images for <query> and returns a top result.
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

# google api
svc = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
svc.key = ENV['CUSTOMSEARCH_API_KEY']

IMAGE_REGEXP = /^dokkoi\s+image\s+(.+)/
bot.message(with_text: IMAGE_REGEXP) do |event|
  query = IMAGE_REGEXP.match(event.content)[1]
  result = svc.list_cses(
    num: 10,
    search_type: 'image',
    cx: ENV['CUSTOMSEARCH_ENGINE_ID'],
    lr: 'lang_ja',
    q: query
  )
  items = result.items
  if items.nil? || items.empty?
    event.respond 'No image'
  else
    event.respond items.sample.link
  end
end

bot.run(true)
