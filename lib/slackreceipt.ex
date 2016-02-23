defmodule SlackReceipt do
  use Application

  # David is awesome

  # See http://elixir-lang.org/docs/stable/elixir/Application.html
  # for more information on OTP Applications
  def start(_type, args) do
    import Supervisor.Spec, warn: false

    children = [
      worker(SlackReceipt.Slack, args)
    ]

    # See http://elixir-lang.org/docs/stable/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Dryfus.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
