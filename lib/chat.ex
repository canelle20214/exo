defmodule Chat do
  use GenServer
  require Logger


  def start_link(opt) do
    GenServer.start_link(__MODULE__, [], opt)
  end

  def init(_) do
    {:ok, []}
  end


  def send_message(pid, message) do
      list = Supervisor.which_children(Sup)
      children = Enum.filter(list, fn {_id, child, _type, module} ->
      module == [__MODULE__] && child !== pid
    end)
    Enum.each(children, fn {_id, child, _type, _modules} ->
      GenServer.cast(child, {:send_message, message, child})
    end)
  end

  def add_message(pid, message) do
    GenServer.cast(pid, {:add_message, message})
  end

  def get_messages(pid) do
    GenServer.call(pid, :get_messages)
  end


  def handle_call(:get_messages, _from, state) do
    {:reply, Enum.reverse(state), state}
  end

  def handle_cast({:add_message, message}, state) do
    {:noreply, [ message | state ]}
  end

  def handle_cast({:send_message, message, to}, state) do
    Chat.add_message(to, message)
    {:noreply, state}
  end

end
