defmodule Apology.Repo do
  use Ecto.Repo,
    otp_app: :apology,
    adapter: Ecto.Adapters.Postgres
end
