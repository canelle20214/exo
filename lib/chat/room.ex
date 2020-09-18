defmodule Chat.Room do
  use Ecto.Schema
  import Ecto.Changeset

  schema "room" do
    field :name, :string
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end


  def changeset(room, params \\ %{}) do
    room
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> change(inserted_at: DateTime.truncate(DateTime.utc_now(), :second), updated_at: DateTime.truncate(DateTime.utc_now(), :second))
  end
end
