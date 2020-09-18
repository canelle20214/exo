defmodule Chat.Repo.Migrations.CreateRoom do
  use Ecto.Migration

  def change do
    create table(:room) do
      add :name, :string, size: 40

      timestamps(:utc_datetime)
    end
    create unique_index(:room, [:name])

  end
end
