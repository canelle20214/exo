defmodule Chat.Room do
  use Ecto.Schema

  schema "room" do
    field :name, :string
    field :inserted_at, :naive_datetime
  end
end
