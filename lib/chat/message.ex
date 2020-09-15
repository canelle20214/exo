defmodule Chat.Message do
  use Ecto.Schema

  schema "message" do
    field :user_id, :integer
    field :room_id, :integer
    field :content, :string
    field :inserted_at, :naive_datetime
  end
end
