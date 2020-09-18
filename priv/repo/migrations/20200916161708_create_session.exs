defmodule Chat.Repo.Migrations.CreateSession do
  use Ecto.Migration

  def change do
    create table(:session) do
      add :user_id, references(:user, [ on_delete: :delete_all, on_update: :update_all ])
      add :room_id, references(:room, [ on_delete: :delete_all, on_update: :update_all ])
      add :socket, :string, size: 40

      timestamps(:utc_datetime)
    end
  end
end
