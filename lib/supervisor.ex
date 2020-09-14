defmodule Chat.Supervisor do
  use Supervisor

  def start_link(_) do
    children = [
      {Cluster.Supervisor, [Application.get_env(:libcluster, :topologies), [name: MyApp.ClusterSupervisor]]}
    ]
    Supervisor.start_link(children, [strategy: :one_for_one, name: Sup, supervisor: {Node.self(), :sup}])
  end

  def init(_init_arg) do
    # {:ok, port} = Application.get_env(:port)
    # {:ok, listensocket} = :gen_tcp.listen(port, [{:active,:once}, {:packet,:line}])
    # [{socket,
    # {sockserv_serv, start_link, [listensocket]}, :temporary, 1000, :worker, [:sockserv_serv]}
    # ]
    # Process.spawn(fn -> empty_listeners() end)
    children = []
    Supervisor.init(children, strategy: :one_for_one)
  end


  def start_child(module, id) do
    Supervisor.start_child(Sup, %{:id => id, :start => {module, :start_link, id}})
  end



  # def start_socket do
  #   Supervisor.start_child(__MODULE__, [])
  # end

  # def empty_listeners do
  #   [start_socket() || Range.new(1, 20)]
  # end

end
