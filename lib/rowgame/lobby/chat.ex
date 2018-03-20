defmodule Rowgame.Lobby.Chat do
  use Ecto.Schema
  import Ecto.Changeset


  schema "chats" do
    field :message, :string, null: false
    field :time, :utc_datetime, null: false
    belongs_to :game, Rowgame.Lobby.Game
    belongs_to :user, Rowgame.Accounts.User

    timestamps()
  end

  @doc false
  def changeset(chat, attrs) do
    chat
    |> cast(attrs, [:time, :message, :game_id, :user_id])
    |> validate_required([:time, :message, :game_id, :user_id])
  end
end
