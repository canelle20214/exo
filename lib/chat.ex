defmodule Chat do
  defmodule State do
    defstruct [:name, :socket, :session, :room]
  end
  alias Chat.State
  use GenServer
  require Logger

  def start_link(socket) do
    IO.inspect(socket)
    GenServer.start_link(__MODULE__, socket)
  end

  def init(socket) do
    Logger.warn "#{inspect socket} init"
    :gen_tcp.send(socket, "\r\n Welcome ! Please enter the name of the group you want to join. \r\n \r\n")
    {:ok, %State{socket: socket}}
  end


  def handle_info({:tcp_closed, socket}, state) do
    Logger.info "#{inspect socket} just closed"
    {:stop, :normal, state}
  end

  def handle_info({:tcp_error, _socket, reason}, state) do
    Logger.error reason
    {:stop, reason, state}
  end

  def handle_info({:tcp, socket, data}, %State{room: nil, name: nil} = state) do
    case Chat.Request.get_room_id(String.trim(data)) do
      -1 -> :gen_tcp.send(state.socket, "\r\n----------------------------------\r\n You just create the group '#{String.trim(data)}' !\r\n----------------------------------\r\n\r\n")
      _ -> :gen_tcp.send(state.socket, "\r\n----------------------------------\r\n You join the group #{String.trim(data)}.\r\n----------------------------------\r\n\r\n")
    end
    Chat.Request.pick_room(String.trim(data))
    :pg2.create(String.trim(data))
    :pg2.join(String.trim(data), self())
    :gen_tcp.send(socket, "\r\n What is your name ? \r\n \r\n")
    newstate = struct(State, [room: String.trim(data), socket: state.socket])
    {:noreply, newstate}
  end

  def handle_info({:tcp, _socket, data}, %State{name: nil} = state) do
    case Chat.Request.get_user_id(String.trim(data)) do
      -1 -> :gen_tcp.send(state.socket, "\r\n----------------------------------\r\n Nice to meet you #{String.trim(data)} !\r\n----------------------------------\r\n\r\n")
      _ -> :gen_tcp.send(state.socket, "\r\n----------------------------------\r\n Happy to see you again #{String.trim(data)} !\r\n----------------------------------\r\n\r\n")
    end
    Chat.Request.pick_user(String.trim(data))
    session_id = Chat.Request.add_session(state.socket, String.trim(data), state.room)
    newstate = struct(State, [name: String.trim(data), session: session_id, room: state.room, socket: state.socket])
    :ets.insert(:chat, {newstate.name, self()})
    :pg2.get_members(state.room)
    |> Enum.filter(fn n ->
      n !== self()
    end)
    |> Enum.each(fn n ->
      send(n, {state, "#{state.name} joins the group. \r\n"})
    end)
    {:noreply, newstate}
  end

  def handle_info({:tcp, _socket, "@" <> rest}, state) do
    [ name | _queue ] = String.split(rest)
    mess = String.trim_trailing(rest, name <> " ")
    pid = :ets.lookup(:chat, name)
    send(pid, {state, "#{state.name} said just to you : #{mess}\r\n"})
    {:noreply, state}
  end

  def handle_info({:tcp, _socket, data}, state) do
    Chat.Request.add_message(String.trim(data), state.session)
    :pg2.get_members(state.room)
    |> Enum.filter(fn n ->
      n !== self()
    end)
    |> Enum.each(fn n ->
      send(n, {state, data})
    end)
    {:noreply, state}
  end

  def handle_info({:disconnect, from}, state) do
    :gen_tcp.send(state.socket, "#{from.name} quit the conversation. \r\n\r\n")
    {:noreply, state}
  end

  def handle_info({from, data}, state) do
    :gen_tcp.send(state.socket, "#{from.name} said: #{data} \r\n")
    {:noreply, state}
  end

  def terminate({_reason, _term}, state) do
    Logger.warn "#{state.name} quit the convo weirdly"
    :ok
  end

  def terminate(:normal, state) do
    :pg2.get_members(state.room)
    |> Enum.filter(fn n ->
      n !== self()
    end)
    |> Enum.each(fn n ->
      send(n, {:disconnect, state})
    end)
    Logger.warn "#{state.name} quit the convo"
    :ok
  end

  def terminate(:shutdown, state) do
    Logger.warn "shutdown #{inspect state}"
    :ok
  end

end
