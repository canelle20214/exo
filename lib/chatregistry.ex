defmodule Chat.Registry do
  use GenServer
  require Logger

  def start_link(opts) do
    Logger.info("starting #{__MODULE__}")
    GenServer.start_link(__MODULE__, opts, name: __MODULE__)
  end

  def init(init_arg) do
    {:ok, init_arg}
  end

  def whereis_name(chat_id) do
    Logger.info("#{__MODULE__} searching for chat")
    GenServer.call(__MODULE__, {:whereis_name, chat_id})
  end

  def register_name(chat_id, pid) do
    Logger.info("#{__MODULE__} registering name")
    GenServer.cast(__MODULE__, {:register_name, chat_id, pid})
  end


  def unregister_name(chat_id) do
    GenServer.cast(__MODULE__, {:unregister_name, chat_id})
  end

  def send(chat_id, message) do
    case whereis_name(chat_id) do
      :undefined ->
        {:not_found, {chat_id, message}}
      pid ->
        Kernel.send(pid, message)
        pid

    end
  end
end
