defmodule TeamExample do
  use GenServer

  @name __MODULE__

  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end



  def add(name)do
    GenServer.cast(@name, {:add, name})
  end

  def remove(name)do
    GenServer.cast(@name, {:remove, name})
  end

  def team do
    GenServer.call(@name, :team)
  end


  def init(:ok) do
    {:ok, %{}}
  end


  def handle_cast({:add, name}, state) do
    new_state = Map.put(state, name, :name)
    {:noreply, new_state}
  end

  def handle_cast({:remove, name}, state) do
    new_state = Map.delete(state, name)
    {:noreply, new_state}
  end

  def handle_call(:team, _from, state) do
    {:reply, state, state}
  end
end
