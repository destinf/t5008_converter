require 'support/dummy_exchange_rate_service'

describe T5008Converter::RowData do
  let(:test_row) do
    CSV::Row.new([
                   "quantity",
                   "name of fund",
                   "closing date",
                   "currency (original)",
                   "proceeds of disposition (original)",
                   "adjusted cost base (original)",
                   "outlays and expenses (original)",
                   "gain (or loss) (original)",
                   "currency (converted)",
                   "proceeds of disposition (converted)",
                   "adjusted cost base (converted)",
                   "outlays and expenses (converted)",
                   "gain (or loss) (converted)",
                   "exchange rate used"
                 ],
                 [
                   50,
                   "AMD",
                   "13/1/2020",
                   "USD",
                   2000,
                   1000,
                   0,
                   nil,
                   "CAD",
                   nil,
                   nil,
                   nil,
                   nil
                 ])
  end

  it "takes in a row of data and correctly fills it out" do
    row_data = T5008Converter::RowData.new(test_row, DummyExchangeRateService.new)
    row_data.fill_missing_values!

    expect(row_data.exchange_rate).to eq(1.5)
    expect(row_data.converted_proceeds).to eq(3000)
    expect(row_data.converted_cost).to eq(1500)
    expect(row_data.converted_expenses).to eq(0)
    expect(row_data.converted_gain_loss).to eq(1500)
  end
end
