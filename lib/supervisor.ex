defmodule Chat.Supervisor do
  use Supervisor

  def start_link(_) do
    children = [
      {Cluster.Supervisor, [Application.get_env(:libcluster, :topologies), [name: MyApp.ClusterSupervisor]]}
    ]
    Supervisor.start_link(children, [strategy: :one_for_one, name: Sup, supervisor: {Node.self(), :sup}])
  end

  def init(_init_arg) do
    children = []
    Supervisor.init(children, strategy: :one_for_one)
  end


  def start_child(module, id) do
    Supervisor.start_child(Sup, %{:id => id, :start => {module, :start_link, id}})
  end
end
