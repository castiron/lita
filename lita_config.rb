require './lita-cic-quotes/lib/lita/handlers/cic_quotes'

Lita.configure do |config|
  config.robot.adapter = ENV['ADAPTER'] || :slack

  config.robot.name = ENV["ROBOT_NAME"] || 'Legolas'

  config.robot.log_level = ENV["LOG_LEVEL"] || :info

  config.adapters.shell.private_chat = true

  config.adapters.slack.token = ENV["SLACK_TOKEN"]

  # REDIS
  if ENV["REDISTOGO_URL"]
    config.redis[:url] = ENV["REDISTOGO_URL"]
  else
    config.redis[:host] = ENV['REDIS_HOST'] || "localhost"
    config.redis[:port] = ENV['REDIS_PORT'] || "6379"
  end

  # HANDLERS (PLUGINS) CONFIG
  config.handlers.cic_quotes.api_key = ENV["AIRTABLE_API_KEY"]
  config.handlers.cic_quotes.table_id = ENV["AIRTABLE_TABLE_ID"]
end
