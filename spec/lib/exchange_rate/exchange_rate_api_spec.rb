describe T5008Converter::ExchangeRate::ExchangeRateApi do
  before do
    allow(Net::HTTP).to receive(:get).and_return("{\"rates\":{\"CAD\":1.304511954,\"HKD\":7.7749415783,\"ISK\":123.314758224,\"PHP\":50.4646773324,\"DKK\":6.7168793816,\"HUF\":300.4583857631,\"CZK\":22.6766133381,\"GBP\":0.7708071185,\"RON\":4.2948049614,\"SEK\":9.4911019234,\"IDR\":13700.9976631314,\"INR\":70.8453172749,\"BRL\":4.1193600575,\"RUB\":61.198364192,\"HRK\":6.6910839475,\"JPY\":109.8777637965,\"THB\":30.2175085386,\"CHF\":0.9716879382,\"EUR\":0.8987956139,\"MYR\":4.0624662952,\"BGN\":1.7578644616,\"TRY\":5.8618551141,\"CNY\":6.8934927198,\"NOK\":8.8940319971,\"NZD\":1.5071903649,\"ZAR\":14.3760560848,\"USD\":1.0,\"MXN\":18.7923782132,\"SGD\":1.3472047456,\"AUD\":1.4485888909,\"ILS\":3.4697105878,\"KRW\":1157.7296422793,\"PLN\":3.8062196656},\"base\":\"USD\",\"date\":\"2020-01-13\"}")
  end

  it "gets an exchange rate" do
    er_instance = T5008Converter::ExchangeRate::ExchangeRateApi.new

    result = er_instance.get_exchange_rate("13/1/2020", "USD", "CAD")
    expect(result).to eq(1.304511954)
  end
end
