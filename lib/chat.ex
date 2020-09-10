defmodule Chat do
  use GenServer
  require Logger


  def start_link(opt) do
    GenServer.start_link(__MODULE__, [], opt)
  end

  def init(_) do
    {:ok, []}
  end


  def send_message(name, message) do
    Supervisor.which_children(Sup)
    |> Enum.filter(fn {id, _child, _type, module} ->
      module == [__MODULE__] && id !== name
    end)
    |> Enum.each(fn {id, _child, _type, _modules} ->
      GenServer.cast(id, {:send_message, message, id})
    end)
  end

  def add_message(name, message) do
    GenServer.cast(name, {:add_message, message})
  end

  def get_messages(name) do
    GenServer.call(name, :get_messages)
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
