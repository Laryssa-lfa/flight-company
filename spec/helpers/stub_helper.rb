# frozen_string_literal: true

module StubHelper
  def stub_get_request(url:, status: 200, response: [])
    stub_request(:get, url)
      .with(
        headers: {
          Accept: '*/*',
          'Accept-Encoding': 'gzip;q=1.0,deflate;q=0.6,identity;q=0.3',
          Host: ENV.fetch('HOST_API'),
          'User-Agent': 'Ruby',
          'X-Rapidapi-Host': ENV.fetch('HOST_API'),
          'X-Rapidapi-Key': ENV.fetch('KEY_API')
        }
      ).to_return(
        status: status,
        body: response&.to_json,
        headers: {}
      )
  end
end
