defmodule Nabp.Repo do
  use Ecto.Repo,
    otp_app: :nabp,
    adapter: Ecto.Adapters.Postgres
end
