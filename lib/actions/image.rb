# frozen_string_literal: true

require 'discordrb'
require 'google/apis/customsearch_v1'

module Actions
  module Image
    extend Discordrb::EventContainer

    IMAGE_REGEXP = /^dokkoi\s+image\s+(.+)/
    message(with_text: IMAGE_REGEXP) do |event|
      query = IMAGE_REGEXP.match(event.content)[1]
      result = google_api_service.list_cses(
        num: 10,
        search_type: 'image',
        cx: ENV.fetch('CUSTOMSEARCH_ENGINE_ID'),
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

    module_function

    def google_api_service
      @google_api_service ||= begin
        svc = Google::Apis::CustomsearchV1::CustomSearchAPIService.new
        svc.key = ENV.fetch('CUSTOMSEARCH_API_KEY')
        svc
      end
    end
  end
end
