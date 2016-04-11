# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

config :slackreceipt, :slack,
  token: System.get_env("SLACK_TOKEN"),
  channel_id: System.get_env("SLACK_CHANNEL_ID")
config :slackreceipt, :oauth,
  consumer_key: System.get_env("XERO_CONSUMER_KEY"),
  private_key_contents: System.get_env("XERO_PRIVATE_KEY_CONTENTS")

if File.exists?("config/config.secret.exs") do
  import_config "config.secret.exs"
end

