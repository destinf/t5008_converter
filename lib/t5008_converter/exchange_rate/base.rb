# lib/base.rb

module T5008Converter::ExchangeRate
  class Base
    def get_exchange_rate(date, from_curr, to_curr)
      raise NotImplementedError
    end
  end
end
