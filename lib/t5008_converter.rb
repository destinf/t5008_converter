require "t5008_converter/version"
require "t5008_converter/row_data"
require "t5008_converter/exchange_rate/exchange_rate_api"
require "csv"

module T5008Converter
  class Error < StandardError; end

    REQUIRED_INPUT_COLUMNS = [
      "quantity",
      "closing date",
      "currency (original)",
      "proceeds of disposition (original)",
      "adjusted cost base (original)",
      "outlays and expenses (original)",
      "currency (converted)"
    ]

    COLUMNS = REQUIRED_INPUT_COLUMNS + [
      "name of fund",
      "gain (or loss) (original)",
      "proceeds of disposition (converted)",
      "adjusted cost base (converted)",
      "outlays and expenses (converted)",
      "gain (or loss) (converted)",
      "exchange rate used"]

  def self.generate_template(output_template_file_name)
    CSV.open(output_template_file_name, "wb",
             write_headers: true,
             headers: COLUMNS) do |output_csv|
    end
  end

  def self.fill_csv(input_file_name, output_file_name, exchange_rate_service)
    CSV.open(output_file_name, "wb",
             write_headers: true,
             headers: COLUMNS) do |output_csv|

      CSV.foreach(input_file_name, headers: true) do |row|
        row_data = RowData.new(row, exchange_rate_service)
        row_data.fill_missing_values!
        output_csv << convert_row_data_to_row(row_data)
      end
    end
  end

  private

  def self.convert_row_data_to_row(row_data)
    [
      row_data.quantity,
      row_data.closing_date,
      row_data.original_currency,
      row_data.original_proceeds,
      row_data.original_cost,
      row_data.original_expenses,
      row_data.converted_currency,
      row_data.name,
      row_data.original_gain_loss,
      row_data.converted_proceeds,
      row_data.converted_cost,
      row_data.converted_expenses,
      row_data.converted_gain_loss,
      row_data.exchange_rate
    ]
  end
end
