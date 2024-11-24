defmodule FormRecoverable.Repo do
  use Ecto.Repo,
    otp_app: :form_recoverable,
    adapter: Ecto.Adapters.Postgres
end
