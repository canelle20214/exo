defmodule Chat.Server do
  require Logger
  use GenServer



  def start_link(listensocket) do
    GenServer.start_link(__MODULE__, listensocket)
  end

  def init(listensocket) do
    send(self(), {:accept, listensocket})
    {:ok, listensocket}
  end

  def handle_info({:accept, listensocket}, state) do
    case :gen_tcp.accept(listensocket) do
      {:ok, socket} ->
        {:ok, pid} = Chat.start_link(socket)
        :gen_tcp.controlling_process(socket, pid)
      err ->
        Logger.error "No socket #{inspect err}"
    end
    Chat.DynamicSupervisor.start_child()
    {:noreply, state}
  end

end
