defmodule Exercice do
  use GenServer

  @name __MODULE__

  def start_link(_) do
    GenServer.start_link(__MODULE__, :ok, [name: @name])
  end

  def init(:ok) do
    {:ok, []}
  end

  def send(msg) do
    GenServer.cast(@name, {:send, {Node.self(), msg}})
  end

  def show do
    GenServer.multi_call(@name, :show)
  end

  def handle_cast({:send, msg}, state) do
    {:noreply, [ msg | state ]}
  end

  def handle_call(:show, _from, state) do
    {:reply, state, state}
  end

end
