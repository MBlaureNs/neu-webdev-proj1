defmodule Rowgame.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset


  schema "users" do
    field :username, :string
    has_many :hosted_game, Rowgame.Lobby.Game, foreign_key: :host_id
    has_many :joined_game, Rowgame.Lobby.Game, foreign_key: :client_id
    
    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username])
    |> validate_required([:username])
    |> unique_constraint(:username)
  end
end
