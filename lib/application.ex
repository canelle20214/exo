defmodule FifoApplication do
  use Application

  def start(_type, _arg) do
    # children = [ Fifo.start_link, name: Fifo ]
    # opts = [strategy: :one_for_one, name: Fifo.Supervisor]
    # Supervisor.start_link(children, opts)
    FifoSupervisor.start_link(name: FifoSupervisor)
  end

  def stop()do
    Supervisor.stop(Fifo)
  end

end
