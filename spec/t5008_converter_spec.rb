require 'support/dummy_exchange_rate_service'

describe T5008Converter do
  describe ".generate_template" do
    let(:dummy_file_name) { "spec/dummy/template.csv" }

    after do
      File.delete(dummy_file_name)
    end

    it "generates a file with the correct headers" do
      T5008Converter.generate_template(dummy_file_name)
      CSV.open(dummy_file_name, "r") do |csv|
        header = csv.readline()
        expect(header).to eq([
                               "quantity",
                               "closing date",
                               "currency (original)",
                               "proceeds of disposition (original)",
                               "adjusted cost base (original)",
                               "outlays and expenses (original)",
                               "currency (converted)",
                               "name of fund",
                               "gain (or loss) (original)",
                               "proceeds of disposition (converted)",
                               "adjusted cost base (converted)",
                               "outlays and expenses (converted)",
                               "gain (or loss) (converted)",
                               "exchange rate used"
                             ])
      end
    end
  end

  describe ".fill_csv" do
    let(:input_filename) { "spec/fixtures/test.csv" }
    let(:output_filename) { "spec/dummy/convert.csv" }
    let(:exchange_rate_service) { DummyExchangeRateService.new }

    after do
      File.delete(output_filename)
    end

    it "successfully fills a csv with the missing values" do
      T5008Converter.fill_csv(input_filename, output_filename, exchange_rate_service)

      row_count = 0
      CSV.foreach(output_filename, headers: true) do |row|
        row_count += 1
        row_data = T5008Converter::RowData.new(row, exchange_rate_service)
        expect(row_data.original_gain_loss).to eq(3000)
        expect(row_data.converted_proceeds).to eq(7500)
        expect(row_data.converted_cost).to eq(3000)
        expect(row_data.converted_expenses).to eq(0)
        expect(row_data.converted_gain_loss).to eq(4500)
      end

      expect(row_count).to eq(1) # There should only be one row
    end
  end
end
