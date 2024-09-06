# frozen_string_literal: true

require 'net/http'

class RequestHttpService
  def initialize(url)
    @url = url
  end

  def self.request(url)
    new(url).request_api
  end

  def request_api
    request_http
  end

  private

  attr_reader :url

  def request_http
    http = Net::HTTP.new(url.host, url.port)
    http.use_ssl = true

    request = Net::HTTP::Get.new(url)
    request['x-rapidapi-key'] = ENV.fetch('KEY_API')
    request['x-rapidapi-host'] = ENV.fetch('HOST_API')

    result = http.request(request).read_body
    JSON.parse(result, symbolize_names: true)
  end
end
