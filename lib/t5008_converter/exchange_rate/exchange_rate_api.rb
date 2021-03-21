# lib/exchange_rate_api.rb
require 'net/https'
require 'uri'
require "date"
require "t5008_converter/exchange_rate/base"
require "json"

module T5008Converter::ExchangeRate
  class ExchangeRateApi < Base
    # API class for exchangerates.io

    ROOT_URI = "https://api.exchangeratesapi.io"

    def get_exchange_rate(date_string, from_curr, to_curr)
      uri = generate_uri(date_string, from_curr)
      res = Net::HTTP.get(uri)
      JSON.parse(res)["rates"][to_curr]
    end

    private

    def generate_uri(date_string, from_curr)
      date = Date.parse(date_string)
      year = date.year
      month = date.month
      day = date.day
      params = { base: from_curr }
      uri = URI("#{ROOT_URI}/#{year}-#{month}-#{day}")
      uri.query = URI.encode_www_form(params)
      uri
    end
  end
end
