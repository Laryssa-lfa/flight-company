# frozen_string_literal: true

require 'net/http'
require 'uri'
require 'json'
require './file_env'

# Class responsible for making an HTTP request
class HttpService
  attr_reader :url

  def initialize(url)
    @url = URI(url)
  end

  def self.request(url)
    new(url).execute
  end

  def execute
    request_http
  end

  private

  ENV = FileEnv.execute

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
