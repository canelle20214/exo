defmodule Fifo do
  use GenServer

  @name __MODULE__


  def start_link do
    GenServer.start_link(__MODULE__, :ok, name: @name)
  end



  def push(element)do
    GenServer.cast(@name, {:push, element})
  end

  def pop do
    GenServer.call(@name, :pop)
  end



  def init(:ok) do
    {:ok, %{}}
  end



  def handle_cast({:push, element}, status) do
    fifo =
      if Map.has_key?(status, :fifo) do
        {_a, b} = Map.fetch(status, :fifo)
        b
      else
        :queue.new()
      end
    new_queue = :queue.in(element, fifo)
    {:noreply, Map.put(status, :fifo, new_queue)}
  end


  def handle_call(:pop, _from, status) do
    fifo =
      if Map.has_key?(status, :fifo) do
        {_a, b} = Map.fetch(status, :fifo)
        b
      else
        :queue.new()
      end
    {new_queue, last_element} =
      unless :queue.is_empty(fifo) do
        {:queue.drop(fifo), :queue.get(fifo)}
      else
        {:queue.new(), :noelement}
      end
    {:reply, {:ok, last_element}, Map.put(status, :fifo, new_queue)}
  end


end
