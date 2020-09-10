defmodule Chat.Supervisor do
  use Application


  def start(_type, _arg) do
    children = [
      %{:id => :primary,
      :start => {Chat, :start_link, [[name: :primary]]}
    }
    ]
    Supervisor.start_link(children, [strategy: :one_for_one, name: Sup])
  end

  def start_child(module, id) do
    Supervisor.start_child(Sup, %{:id => id, :start => {module, :start_link, [[name: id]]}})
  end
end
