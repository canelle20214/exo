defmodule Fifo do
  use GenServer

  @name __MODULE__


  def start_link(opt) do
    GenServer.start_link(__MODULE__, :ok, opt)
  end



  def push(element)do
    GenServer.cast(@name, {:push, element})
  end

  def pop do
    GenServer.call(@name, :pop)
  end



  def init(:ok) do
    {:ok, []}
  end



  def handle_cast({:push, element}, state) do
    list = [ element | state ]
    {:noreply, list}
  end

  def handle_call(:pop, _from, []) do
    {:reply, nil, []}
  end

  def handle_call(:pop, _from, state) do
    [ head | tail ] = Enum.reverse(state)
    {:reply, head, Enum.reverse(tail)}
  end

end
