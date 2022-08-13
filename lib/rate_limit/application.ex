defmodule RateLimit.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      # Start the Telemetry supervisor
      RateLimitWeb.Telemetry,
      # Start the PubSub system
      {Phoenix.PubSub, name: RateLimit.PubSub},
      # Start the Endpoint (http/https)
      RateLimitWeb.Endpoint
      # Start a worker by calling: RateLimit.Worker.start_link(arg)
      # {RateLimit.Worker, arg}
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: RateLimit.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    RateLimitWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
