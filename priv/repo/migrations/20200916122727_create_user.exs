defmodule Chat.Repo.Migrations.CreateUser do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string, size: 40

      timestamps(:utc_datetime)
    end
    create unique_index(:user, [:name])

  end
end
