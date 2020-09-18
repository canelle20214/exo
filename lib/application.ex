defmodule Chat.Application do
  use Application
  require Logger

  def start(_, _) do
    :pg2.create(:first_group)
    children = [
      Chat.Repo,
      %{
        id: Chat.DynamicSupervisor,
        start: {Chat.DynamicSupervisor, :start_link, [ strategy: :one_for_one]}
      },
      Chat.Supervisor
    ]
    Supervisor.start_link(children, strategy: :one_for_one)
  end

end
