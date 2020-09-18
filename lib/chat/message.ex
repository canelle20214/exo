defmodule Chat.Message do
  use Ecto.Schema
  import Ecto.Changeset

  schema "message" do
    field :user_id, :integer
    field :room_id, :integer
    field :content, :string
    field :inserted_at, :utc_datetime
    field :updated_at, :utc_datetime
  end


  def changeset(message, params \\ %{}) do
    message
    |> cast(params, [:content, :user_id, :room_id])
    |> validate_required([:user_id, :room_id])
    |> change(inserted_at: DateTime.truncate(DateTime.utc_now(), :second), updated_at: DateTime.truncate(DateTime.utc_now(), :second))
  end
end
