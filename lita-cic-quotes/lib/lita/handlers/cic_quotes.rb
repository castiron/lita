require 'active_support/all'

module Lita
  module Handlers
    class CicQuotes < Handler
      config :api_key
      config :table_id

      def pull_data
        @client = Airtable::Client.new(config.api_key)
        @quotes = @client.table(config.table_id, "Quotes")
        @peeps = @client.table(config.table_id, "Peeps")
        @batch = @quotes.all
        [@batch, @peeps]
      end

      def get_id_by_name(peep_records, name)
        id = nil
        peep_records.each do |peep|
          if peep["First Name"].downcase == name.downcase
            id = peep[:id]
          end
        end

        id
      end

      def filter_batch_by_name(batch, peeps, name, response)
        # Pass peep table records to get ID
        peep_id = get_id_by_name(peeps.records, name)

        if peep_id
          batch = batch.select do |quote|
            unless quote["Said_By"].empty?
              quote["Said_By"].any? {|id| id == peep_id}
            end
          end
        else
          response.reply "I don't believe we've got a human with the first name `#{name}` here. I'll simply choose at random:"
        end

        batch
      end

      def attribute_quote(record, peeps)
        # Look up the Said_By id
        peeps_said = record["Said_By"]

        # Build a string of all the people who said the quote
        peeps_names = ""
        peeps_said.each_with_index do |id, index|
          peep_record = peeps.find(id)
          # Comma separate names if index is greater than 0
          peeps_names = peeps_names + ', ' if index > 0
          peeps_names = peeps_names + peep_record["First Name"]
        end

        # Return that random quote
        "#{record["Quote"]}\r\n-- #{peeps_names}"
      end

      def handle_quote(response)
        response.reply response.matches[0].to_s
        # Get quote batch and people table
        batch, peeps = pull_data

        # If there was a name parameter
        if response.matches[0][1]
          # Attempt to filter the batch
          batch = filter_batch_by_name(batch, peeps, response.matches[0][1], response)
        end

        record = batch[rand(batch.length)]

        response.reply attribute_quote(record, peeps)
      end

      # insert handler code here
      route(/^(quote)[\s{1,}]?([a-zA-Z_]+)?[\s{1,}]?(latest)?/, :handle_quote, command: true)

      Lita.register_handler(self)
    end
  end
end
