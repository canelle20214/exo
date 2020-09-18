defmodule Chat.User do
  use Ecto.Schema
  import Ecto.Changeset

  schema "user" do
    field :name, :string
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end


  def changeset(user, params \\ %{}) do
    user
    |> cast(params, [:name])
    |> validate_required([:name])
    |> unique_constraint(:name)
    |> change(inserted_at: DateTime.truncate(DateTime.utc_now(), :second), updated_at: DateTime.truncate(DateTime.utc_now(), :second))
  end
end
