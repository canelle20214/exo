defmodule Fifo do
  use GenServer

  @name __MODULE__


  def start_link do
    GenServer.start_link(__MODULE__, :queue.new(), name: @name)
  end



  def push(element)do
    GenServer.cast(@name, {:push, element})
  end

  def pop(element)do
    GenServer.cast(@name, {:pop, element})
  end



  def init(_) do
    {:ok, %{}}
  end

  def handle_cast({:push, element}, fifo) do
    new_queue = :queue.in(element, fifo)
    {:reply, {:ok, element}, new_queue}
  end


  def handle_cast({:pop, element}, fifo) do
    {new_queue, last_element} =
    with :queue.is_empty(fifo) <- true,
      do: {:queue.drop(fifo), :queue.get(fifo)}
    {:reply, {:ok, last_element}, new_queue}
  end


end
