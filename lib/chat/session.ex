defmodule Chat.Session do
  use Ecto.Schema
  import Ecto.Changeset

  schema "session" do
    field :user_id, :integer
    field :room_id, :integer
    field :socket, :string
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end


  def changeset(session, params \\ %{}) do
    session
    |> cast(params, [:socket, :user_id, :room_id])
    |> validate_required([:socket, :user_id, :room_id])
    |> change(inserted_at: DateTime.truncate(DateTime.utc_now(), :second), updated_at: DateTime.truncate(DateTime.utc_now(), :second))
  end
end
