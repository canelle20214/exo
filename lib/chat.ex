defmodule Chat do
  defmodule State do
    defstruct [:name, :socket]
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
    :gen_tcp.send(socket, "What is your name ? \r\n")
    :pg2.join(:first_group, self())
    {:ok, %State{socket: socket}}
  end

  def handle_info({:tcp, socket, data}, %State{name: nil} = state) do
    name = String.replace(data, "\r\n", "")
    newstate = struct(State, [name: name, socket: state.socket])
    :gen_tcp.send(state.socket, "Nice to meet you #{newstate.name}\r\n")
    {:noreply, newstate}
  end

  def handle_info({:tcp, socket, data}, state) do
    :pg2.get_members(:first_group)
    |> Enum.filter(fn n ->
      n !== self()
    end)
    |> Enum.each(fn n ->
      send(n, {state, data})
    end)
    {:noreply, state}
  end

  def handle_info({from, data}, state) do # when from !== socket
    :gen_tcp.send(state.socket, "#{from.name} said: #{data}")
    {:noreply, state}
  end

  def handle_info({:tcp_closed, socket}, state) do
    Logger.info "#{socket} just closed"
  end

  def handle_info({:tcp_error, socket, reason}, state) do
    Logger.error reason
  end



  # :inet.setopts(socket, active: :once)


  # def send_message(pid, message) do
  #   :pg2.get_members(:first_group)
  #   |> Enum.filter(fn n ->
  #     n !== pid
  #   end)
  #   |> Enum.each(fn n ->
  #     GenServer.cast(n, {:send_message, message, n})
  #   end)
  # end

  # def add_message(pid, message) do
  #   GenServer.cast(pid, {:add_message, message})
  # end

  # def get_messages(pid) do
  #   GenServer.call(pid, :get_messages)
  # end



  # def handle_call(:get_messages, _from, state) do
  #   {:reply, Enum.reverse(state), state}
  # end

  # def handle_cast({:add_message, message}, state) do
  #   {:noreply, [ message | state ]}
  # end

  # def handle_cast({:send_message, message, to}, state) do
  #   Chat.add_message(to, message)
  #   {:noreply, state}
  # end

end
