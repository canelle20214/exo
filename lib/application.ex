defmodule Chat.Application do
  use Application
  require Logger


  def start(_, _) do
    {:ok, _pid} = Postgrex.start_link(hostname: "localhost", username: "postgres", password: "postgres", database: "db_chat")
    # Logger.warn "le pid #{inspect pid}"
    port = String.to_integer(System.get_env("PORT") || "4040")
    Chat.Server.start(port)
    :pg2.create(:first_group)
    |> IO.inspect()
    Supervisor.start_link([ Chat.Supervisor ], strategy: :one_for_one)
  end

end
