defmodule Chat.Repo do
  use Ecto.Repo,
    otp_app: :exo,
    adapter: Ecto.Adapters.Postgres

end
