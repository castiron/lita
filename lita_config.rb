require 'dotenv/load'

require './lita-cic-quotes/lib/lita/handlers/cic_quotes'

Lita.configure do |config|
  # The name your robot will use.
  config.robot[:name] = ENV["ROBOT_NAME"] ? ENV["ROBOT_NAME"] : 'Legolas'

  # The locale code for the language to use.
  #config.robot.locale = :en

  # The severity of messages to log. Options are:
  # :debug, :info, :warn, :error, :fatal
  # Messages at the selected level and above will be logged.
  config.robot[:log_level] = :info

  # An array of user IDs that are considered administrators. These users
  # the ability to add and remove other users from authorization groups.
  # What is considered a user ID will change depending on which adapter you use.
  # config.robot.admins = ["1", "2"]

  ## Example: Set options for the chosen adapter.
  # config.adapter.username = "myname"
  # config.adapter.password = "secret"

  ## Example: Set options for the Redis connection.
  # config.redis[:url] = ENV["BOXEN_REDIS_URL"]
  # config.redis[Lport] = ENV["BOXEN_REDIS_PORT"]

  ## Heroku Redis To-Go connection
  # Uncomment to use Heroku configuration
  #config.redis[:url] = ENV["REDISTOGO_URL"]
  #config.http[:port] = ENV["REDISTOGO_PORT"]

  config.redis[:host] = "redis"

  ## Example: Set configuration for any loaded handlers. See the handler's
  ## documentation for options.
  # config.handlers.some_handler.some_config_key = "value"
  config.handlers.google_images.google_cse_id = ENV["GOOGLE_CSE_ID"]
  config.handlers.google_images.google_cse_key = ENV["GOOGLE_CSE_KEY"]

  ## Config for Slack Robot adapter
  config.robot.adapter = :slack
  # config.robot.admins = ["U026ARU7X"]

  config.adapters.slack.token = ENV["SLACK_TOKEN"]
  # config.adapters.slack.link_names = true
  # config.adapters.slack.parse = "full"
  # config.adapters.slack.unfurl_links = false
  # config.adapters.slack.unfurl_media = true

  # Faker config
  # NB: Faker (and this config) may need to be commented out to work on Mac OS X right now
#config.robot.locale = 'en_US'

  # Doge words
  config.handlers.doge.default_words = ["jam", "server", "repo", "glorp", "freshie"]

  # CIC Quotes config
  config.handlers.cic_quotes.api_key = ENV["AIRTABLE_API_KEY"]
  config.handlers.cic_quotes.table_id = ENV["AIRTABLE_TABLE_ID"]
end
