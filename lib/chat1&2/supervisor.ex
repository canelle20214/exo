defmodule CoupleChat.Supervisor do
  use Application

  def start(_type, _arg) do
    children = [ FirstChat, SecondChat ]
    Supervisor.start_link(children, [strategy: :one_for_one])
  end

end
