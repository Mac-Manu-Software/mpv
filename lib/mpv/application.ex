defmodule Mpv.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      MpvWeb.Telemetry,
      Mpv.Repo,
      {DNSCluster, query: Application.get_env(:mpv, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: Mpv.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: Mpv.Finch},
      # Start a worker by calling: Mpv.Worker.start_link(arg)
      # {Mpv.Worker, arg},
      # Start to serve requests, typically the last entry
      MpvWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: Mpv.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    MpvWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
