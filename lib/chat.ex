defmodule Chat do
  use GenServer
  alias Chat.Registry, as: Regi

  @registry :chatregistry


  def start_link(_) do
    {ok, _} = Regi.start_link()
    GenServer.start_link(__MODULE__, [], [name: :chat]) #{:via, Chat.Registry, {:where, name} })
  end

  def init(_) do
     {:ok, []}
  end



  def add_message(message) do
    Registry.dispatch(Chat.Registry, @registry, fn entries ->
      for {pid, _} <- entries, do: GenServer.cast(pid, {:add_message, message}) #send(pid, {:send_message, message})
    end)
  end

  def send_message(message) do
    Registry.dispatch(Chat.Registry, @registry, fn entries ->
      for {pid, _} <- entries, do: GenServer.cast(pid, {:send_message, message}) #send(pid, {:send_message, message})
    end)
    # GenServer.cast(:chat, {:send_message, message})
  end

  def get_messages do
    GenServer.call(:chat, :get_messages)
  end




  def handle_call(:get_messages, _from, state) do
    {:reply, state, []}
  end

  def handle_cast(_pid, {:send_message, message}, state) do
    add_message(message)
    {:noreply, state}
  end

  def handle_cast(pid, {:add_message, _message}, state) when pid === self() do
    {:noreply, state}
  end

  def handle_cast(_pid, {:add_message, message}, state) do
    {:noreply, [ message | state ]}
  end

end
