defmodule Chat.Registry do

  @registry :chatregistry


  def create_key(name), do: {:via, Registry, {@registry, name}}

  def start_link do
    Registry.start_link(keys: :duplicate, name: __MODULE__) # partitions: System.schedulers_online()
  end

  def register(name) do
    Registry.register(__MODULE__, create_key(name), [])
  end

  def get_pid(name) do
    [{pid, _}] = Registry.lookup(@registry, name)
    pid
  end

end
