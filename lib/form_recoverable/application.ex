defmodule FormRecoverable.Application do
  # See https://hexdocs.pm/elixir/Application.html
  # for more information on OTP Applications
  @moduledoc false

  use Application

  @impl true
  def start(_type, _args) do
    children = [
      FormRecoverableWeb.Telemetry,
      FormRecoverable.Repo,
      {DNSCluster, query: Application.get_env(:form_recoverable, :dns_cluster_query) || :ignore},
      {Phoenix.PubSub, name: FormRecoverable.PubSub},
      # Start the Finch HTTP client for sending emails
      {Finch, name: FormRecoverable.Finch},
      # Start a worker by calling: FormRecoverable.Worker.start_link(arg)
      # {FormRecoverable.Worker, arg},
      # Start to serve requests, typically the last entry
      FormRecoverableWeb.Endpoint
    ]

    # See https://hexdocs.pm/elixir/Supervisor.html
    # for other strategies and supported options
    opts = [strategy: :one_for_one, name: FormRecoverable.Supervisor]
    Supervisor.start_link(children, opts)
  end

  # Tell Phoenix to update the endpoint configuration
  # whenever the application is updated.
  @impl true
  def config_change(changed, _new, removed) do
    FormRecoverableWeb.Endpoint.config_change(changed, removed)
    :ok
  end
end
