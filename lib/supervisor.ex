defmodule Message.Supervisor do
  use Application

  def start(_type, _arg) do
    children = [ Message ]
    Supervisor.start_link(children, [strategy: :one_for_one])
  end

end
