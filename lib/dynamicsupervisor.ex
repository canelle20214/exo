defmodule Chat.DynamicSupervisor do
  use DynamicSupervisor
  require Logger


  def start_link(init_arg) do
    DynamicSupervisor.start_link(__MODULE__, init_arg, name: Chat.DynamicSupervisor)
  end

  def start_child do
    spec = %{
      id: Chat.Server,
      start: {Chat.Server, :start_link, []},
      restart: :transient
    }
    DynamicSupervisor.start_child(Chat.DynamicSupervisor, spec)
  end

  @impl true
  def init(_) do
     port = String.to_integer(System.get_env("PORT") || "4040")
    {:ok, listensocket} = :gen_tcp.listen(port, [{:active, true}, {:reuseaddr, true}, :binary])
    DynamicSupervisor.init(
      extra_arguments: [listensocket],
      strategy: :one_for_one
    )
  end

end
