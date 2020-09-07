defmodule FifoApplication do
  use Application

  def start(_type, _arg) do
    FifoSupervisor.start_link(name: FifoSupervisor)
  end

  def stop do
    FifoSupervisor.stop()
  end

end
