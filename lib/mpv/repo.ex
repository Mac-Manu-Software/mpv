defmodule Mpv.Repo do
  use Ecto.Repo,
    otp_app: :mpv,
    adapter: Ecto.Adapters.Postgres
end
