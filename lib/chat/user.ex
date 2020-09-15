defmodule Chat.User do
  use Ecto.Schema

  schema "user" do
    field :name, :string
    field :inserted_at, :naive_datetime
  end
end
