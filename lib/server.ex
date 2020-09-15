defmodule Chat.Server do
  require Logger

  def start(port) do
    {:ok, listensocket} = :gen_tcp.listen(port, [{:active, true}, {:reuseaddr, true}, :binary])
    accept(listensocket)
  end

  def accept(listensocket) do
    case :gen_tcp.accept(listensocket) do
      {:ok, socket} ->
        {:ok, pid} = Chat.start_link(socket)
        :gen_tcp.controlling_process(socket, pid)
      err ->
        Logger.error "No socket #{inspect err}"
    end
    accept(listensocket)
  end

end
