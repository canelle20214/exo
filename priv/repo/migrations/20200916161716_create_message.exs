defmodule Chat.Repo.Migrations.CreateMessage do
  use Ecto.Migration

  def change do
    create table(:message) do
      add :user_id, references(:user, [ on_delete: :delete_all, on_update: :update_all ])
      add :room_id, references(:room, [ on_delete: :delete_all, on_update: :update_all ])
      add :content, :text

      timestamps(:utc_datetime)
    end
  end
end
