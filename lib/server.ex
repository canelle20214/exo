defmodule Chat.Server do
  require Logger
  #méthode 1

  def start(port) do
    {:ok, listensocket} = :gen_tcp.listen(port, [{:active, true}, {:reuseaddr, true}, :binary])
    Process.spawn(fn ->
      accept(listensocket)
    end, [:link])
  end

  def accept(listensocket) do
    case :gen_tcp.accept(listensocket) do
      {:ok, socket} ->
        {:ok, pid} = Chat.start_link(socket)
        :gen_tcp.controlling_process(socket, pid)
      err ->
        Logger.warn "Chat.Server -> no socket"
    end
    accept(listensocket)

  end

end
