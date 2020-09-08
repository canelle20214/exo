defmodule SecondChat do
  use GenServer
  alias FirstChat, as: Recipient


  def start_link(_) do
    GenServer.start_link(__MODULE__, [], [name: :secondchat]) #{:via, Chat.Registry, {:where, name} })
  end

  def init(_) do
     {:ok, []}
  end

  def add_message(message) do
    GenServer.cast(:secondchat, {:add_message, message})
  end

  def send_message(message) do
    GenServer.cast(:secondchat, {:send_message, message})
  end

  def get_messages do
    GenServer.call(:secondchat, :get_messages)
  end

  def handle_call(:get_messages, _from, state) do
    {:reply, state, []}
  end

  def handle_cast({:send_message, message}, state) do
    Recipient.add_message(message)
    {:noreply, state}
  end

  def handle_cast({:add_message, message}, state) do
    {:noreply, [ message | state ]}
  end

end
