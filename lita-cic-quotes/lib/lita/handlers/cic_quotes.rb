require 'active_support/all'

module Lita
  module Handlers
    class CicQuotes < Handler
      config :api_key
      config :table_id

      def quote(response)
        @client = Airtable::Client.new(config.api_key)
        @quotes = @client.table(config.table_id, "Quotes")
        @peeps = @client.table(config.table_id, "Peeps")
        @batch = @quotes.all
        @record = @batch[rand(@batch.length)]
        @peeps_said = @record["Said_By"]
        @peeps_names = ""

        @peeps_said.each_with_index do |id, index|
          @peep_record = @peeps.find(id)
          # Comma separate names if index is greater than 0
          @peeps_names = @peeps_names + ', ' if index > 0
          @peeps_names = @peeps_names + @peep_record["First Name"]
        end

        response.reply "#{@record["Quote"]}\r\n-- #{@peeps_names}"
      end

      # insert handler code here
      route(/^quote/, :quote, command: true)

      Lita.register_handler(self)
    end
  end
end
