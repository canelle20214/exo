defmodule FifoSupervisor do
  use Supervisor
  @name __MODULE__


  def start_link(opts) do
    Supervisor.start_link(@name, :ok, opts)
  end

  def init(:ok) do
    Supervisor.init([{ Fifo, name: Fifo }], strategy: :one_for_one)
  end
end
