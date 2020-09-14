defmodule Chat.Application do
  use Application


  def start(_, _) do
    port = String.to_integer(System.get_env("PORT") || "4040")
    Chat.Server.start(port)
    :pg2.create(:first_group)
    |> IO.inspect()
    Supervisor.start_link([ Chat.Supervisor ], strategy: :one_for_one)
  end

end
