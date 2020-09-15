defmodule Chat.Repo.Migrations.CreateChat do
  use Ecto.Migration

  def change do
    create table(:user) do
      add :name, :string, size: 40

      timestamps()
    end
    create unique_index(:user, [:name])

    create table(:room) do
      add :name, :string, size: 40

      timestamps()
    end
    create unique_index(:room, [:name])

    create table(:message) do
      add :user_id, references(:user, [ on_delete: :delete_all, on_update: :update_all ])
      add :room_id, references(:room, [ on_delete: :delete_all, on_update: :update_all ])
      add :content, :text

      timestamps()
    end

    create table(:session) do
      add :user_id, references(:user, [ on_delete: :delete_all, on_update: :update_all ])
      add :room_id, references(:room, [ on_delete: :delete_all, on_update: :update_all ])
      add :socket, :string, size: 40

      timestamps()
    end

  end
end
