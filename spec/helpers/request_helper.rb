# frozen_string_literal: true

module RequestHelper
  def response_body
    case response.content_type
    when /^application\/json/
      JSON.parse(response.body, symbolize_names: true)
    when /^application\/xml/, /^text\/xml/
      Nokogiri::XML(response.body)
    when /^text\/html/
      Nokogiri::HTML(response.body)
    else
      response.body
    end
  end
end
