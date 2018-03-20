defmodule Rowgame.Lobby.Move do
  use Ecto.Schema
  import Ecto.Changeset


  schema "moves" do
    field :turn, :integer, null: false
    field :x_pos, :integer, null: false
    field :y_pos, :integer, null: false
    belongs_to :game, Rowgame.Lobby.Game

    timestamps()
  end

  @doc false
  def changeset(move, attrs) do
    move
    |> cast(attrs, [:turn, :x_pos, :y_pos, :game_id])
    |> validate_required([:turn, :x_pos, :y_pos, :game_id])
  end
end
