defmodule Rowgame.Lobby.Game do
  use Ecto.Schema
  import Ecto.Changeset


  schema "games" do
    field :board_size, :integer, null: false
    field :cur_turn, :integer, null: false
    field :is_finished, :boolean, default: false, null: false
    field :is_started, :boolean, default: false, null: false
    field :win_length, :integer, null: false
    belongs_to :host, Rowgame.Accounts.User
    belongs_to :client, Rowgame.Accounts.User
    belongs_to :winner, Rowgame.Accounts.User
    has_many :move, Rowgame.Lobby.Move, foreign_key: :game_id

    timestamps()
  end

  @doc false
  def changeset(game, attrs) do
    game
    |> cast(attrs, [:board_size, :win_length, :cur_turn, :is_started, :is_finished, :host_id, :client_id, :winner_id])
    |> validate_required([:board_size, :win_length, :cur_turn, :is_started, :is_finished, :host_id, :client_id, :winner_id])
  end
end
