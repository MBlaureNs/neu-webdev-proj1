defmodule Rowgame.Repo.Migrations.CreateGames do
  use Ecto.Migration

  def change do
    create table(:games) do
      add :board_size, :integer, default: 15, null: false
      add :win_length, :integer, default: 5, null: false
      add :cur_turn, :integer, default: 0, null: false
      add :is_started, :boolean, default: false, null: false
      add :is_finished, :boolean, default: false, null: false
      add :host_id, references(:users, on_delete: :delete_all), null: false
      add :client_id, references(:users, on_delete: :nothing)
      add :winner_id, references(:users, on_delete: :nothing)

      timestamps()
    end

    create index(:games, [:host_id])
    create index(:games, [:client_id])
    create index(:games, [:winner_id])
  end
end
