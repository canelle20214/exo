defmodule Chat.Session do
  use Ecto.Schema

  schema "session" do
    field :user_id, :integer
    field :room_id, :integer
    field :socket, :string
    field :inserted_at, :naive_datetime
  end
end
