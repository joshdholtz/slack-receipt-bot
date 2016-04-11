defmodule SlackReceipt.Mixfile do
  use Mix.Project

  def project do
    [app: :slackreceipt,
     version: "0.0.1",
     elixir: "~> 1.2",
     build_embedded: Mix.env == :prod,
     start_permanent: Mix.env == :prod,
     deps: deps]
  end

  # Configuration for the OTP application
  #
  # Type "mix help compile.app" for more information
  def application do
    [
      applications: [:logger, :httpoison],
      mod: {SlackReceipt, [Application.get_env(:slackreceipt, :slack)[:token]]}
    ]
  end

  # Dependencies can be Hex packages:
  #
  #   {:mydep, "~> 0.3.0"}
  #
  # Or git/path repositories:
  #
  #   {:mydep, git: "https://github.com/elixir-lang/mydep.git", tag: "0.1.0"}
  #
  # Type "mix help deps" for more examples and options
  defp deps do
    [{:websocket_client, github: "jeremyong/websocket_client"},
     {:slacker,  "~> 0.0.2"},
     {:oauth, github: "joshdholtz/erlang-oauth", branch: "private-key-contents"}]
   #{:oauth, github: "tim/erlang-oauth"}]
  end
end
