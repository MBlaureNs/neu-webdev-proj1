defmodule Rowgame.Repo.Migrations.CreateChats do
  use Ecto.Migration

  def change do
    create table(:chats) do
      add :time, :utc_datetime, null: false
      add :message, :text, null: false
      add :game_id, references(:games, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:chats, [:game_id])
    create index(:chats, [:user_id])
  end
end
