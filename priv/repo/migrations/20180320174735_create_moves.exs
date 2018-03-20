defmodule Rowgame.Repo.Migrations.CreateMoves do
  use Ecto.Migration

  def change do
    create table(:moves) do
      add :turn, :integer, null: false
      add :x_pos, :integer, null: false
      add :y_pos, :integer, null: false
      add :game_id, references(:games, on_delete: :delete_all), null: false

      timestamps()
    end

    create index(:moves, [:game_id])
  end
end
