defmodule Apology.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      ApologyWeb.Telemetry,
      Apology.Repo,
      {DNSCluster, query: Application.get_env(:apology, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Apology.PubSub},
      # Start a worker by calling: Apology.Worker.start_link(arg)
      # {Apology.Worker, arg},
      # Start to serve requests, typically the last entry
      ApologyWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Apology.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    ApologyWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
