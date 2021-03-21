# lib/row_data.rb

module T5008Converter
  class RowData
    attr_accessor :quantity,
                  :closing_date,
                  :original_currency,
                  :original_proceeds,
                  :original_cost,
                  :original_expenses,
                  :name,
                  :original_gain_loss,
                  :exchange_rate,
                  :converted_currency,
                  :converted_proceeds,
                  :converted_cost,
                  :converted_expenses,
                  :converted_gain_loss

    attr_reader :exchange_rate_service

    REQUIRED_ATTRIBUTES = %i(original closing_date original_currency
                             original_proceeds original_cost original_expenses
                             converted_currency)

    def initialize(row, exchange_rate_service)
      @quantity            = row["quantity"].to_i
      @closing_date        = row["closing_date"]
      @original_currency   = row["currency (original)"]
      @original_proceeds   = row["proceeds of disposition (original)"].to_f
      @original_cost       = row["adjusted cost base (original)"].to_f
      @original_expenses   = row["outlays and expenses (original)"].to_f
      @original_gain_loss  = row["gain (or loss) (original)"]&.to_f
      @name                = row["name of fund"]
      @exchange_rate       = row["exchange rate used"]&.to_f
      @converted_currency  = row["currency (converted)"]
      @converted_proceeds  = row["proceeds of disposition (converted)"]&.to_f
      @converted_cost      = row["adjusted cost base (converted)"]&.to_f
      @converted_expenses  = row["outlays and expenses (converted)"]&.to_f
      @converted_gain_loss = row["gain (or loss) (converted)"]&.to_f

      @exchange_rate_service = exchange_rate_service

      check_for_required_values
    end

    def fill_missing_values!
      fill_original_gain_loss
      fill_exchange_rate
      fill_converted
    end

    private

    def fill_converted
      @converted_proceeds ||= @original_proceeds * @exchange_rate
      @converted_cost ||= @original_cost * @exchange_rate
      @converted_expenses ||= @original_expenses * @exchange_rate
      @converted_gain_loss ||= @original_gain_loss * @exchange_rate
    end

    def fill_exchange_rate
      @exchange_rate ||= @exchange_rate_service
                       .get_exchange_rate(@closing_date,
                                          @original_currency,
                                          @converted_currency)
    end

    def fill_gain_loss(proceeds, cost, expenses)
      proceeds - cost - expenses
    end

    def fill_original_gain_loss
      @original_gain_loss ||= fill_gain_loss(@original_proceeds,
                                    @original_cost,
                                    @original_expenses)
    end

    def check_for_required_values
      errors = REQUIRED_ATTRIBUTES.map do |column|
        empty?(column) ? column : nil
      end.compact

      unless errors.empty?
        raise T5008Converter::Error.new "Missing required values " + errors.join(", ")
      end

      raise T5008Converter::Error.new "Missing required exchange rate service!" unless @exchange_rate_service
    end

    def empty?(value)
      case value
      when String
        value.strip.empty?
      when nil
        true
      else
        false
      end
    end
  end
end
