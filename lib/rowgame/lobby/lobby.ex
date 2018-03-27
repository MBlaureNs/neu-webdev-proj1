defmodule Rowgame.Lobby do
  @moduledoc """
  The Lobby context.
  """

  import Ecto.Query, warn: false
  alias Rowgame.Repo

  alias Rowgame.Lobby.Game

  @doc """
  Returns the list of games.

  ## Examples

      iex> list_games()
      [%Game{}, ...]

  """
  def list_games do
    Repo.all(Game)
  end

  @doc """
  Gets a single game.

  Raises `Ecto.NoResultsError` if the Game does not exist.

  ## Examples

      iex> get_game!(123)
      %Game{}

      iex> get_game!(456)
      ** (Ecto.NoResultsError)

  """
  def get_game!(id), do: Repo.get!(Game, id)

  def get_game(id) do
    Repo.get(Game, id)
    |> Repo.preload(:host)
    |> Repo.preload(:client)
    |> Repo.preload(:winner)
    |> Repo.preload(:move)
    |> Repo.preload(:chat)
  end

  @doc """
  Creates a game.

  ## Examples

      iex> create_game(%{field: value})
      {:ok, %Game{}}

      iex> create_game(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_game(attrs \\ %{}) do
    %Game{}
    |> Game.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a game.

  ## Examples

      iex> update_game(game, %{field: new_value})
      {:ok, %Game{}}

      iex> update_game(game, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_game(%Game{} = game, attrs) do
    game
    |> Game.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Game.

  ## Examples

      iex> delete_game(game)
      {:ok, %Game{}}

      iex> delete_game(game)
      {:error, %Ecto.Changeset{}}

  """
  def delete_game(%Game{} = game) do
    Repo.delete(game)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking game changes.

  ## Examples

      iex> change_game(game)
      %Ecto.Changeset{source: %Game{}}

  """
  def change_game(%Game{} = game) do
    Game.changeset(game, %{})
  end

  alias Rowgame.Lobby.Move

  @doc """
  Returns the list of moves.

  ## Examples

      iex> list_moves()
      [%Move{}, ...]

  """
  def list_moves do
    Repo.all(Move)
  end

  def list_moves_from_game(id) do
    query = from m in "moves",
      where: m.game_id == ^id,
      select: {m.x_pos, m.y_pos, m.turn}
    Repo.all(query)
  end
  
  @doc """
  Gets a single move.

  Raises `Ecto.NoResultsError` if the Move does not exist.

  ## Examples

      iex> get_move!(123)
      %Move{}

      iex> get_move!(456)
      ** (Ecto.NoResultsError)

  """
  def get_move!(id), do: Repo.get!(Move, id)

  @doc """
  Creates a move.

  ## Examples

      iex> create_move(%{field: value})
      {:ok, %Move{}}

      iex> create_move(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_move(attrs \\ %{}) do
    %Move{}
    |> Move.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a move.

  ## Examples

      iex> update_move(move, %{field: new_value})
      {:ok, %Move{}}

      iex> update_move(move, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_move(%Move{} = move, attrs) do
    move
    |> Move.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Move.

  ## Examples

      iex> delete_move(move)
      {:ok, %Move{}}

      iex> delete_move(move)
      {:error, %Ecto.Changeset{}}

  """
  def delete_move(%Move{} = move) do
    Repo.delete(move)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking move changes.

  ## Examples

      iex> change_move(move)
      %Ecto.Changeset{source: %Move{}}

  """
  def change_move(%Move{} = move) do
    Move.changeset(move, %{})
  end

  alias Rowgame.Lobby.Chat

  @doc """
  Returns the list of chats.

  ## Examples

      iex> list_chats()
      [%Chat{}, ...]

  """
  def list_chats do
    Repo.all(Chat)
  end

  @doc """
  Gets a single chat.

  Raises `Ecto.NoResultsError` if the Chat does not exist.

  ## Examples

      iex> get_chat!(123)
      %Chat{}

      iex> get_chat!(456)
      ** (Ecto.NoResultsError)

  """
  def get_chat!(id), do: Repo.get!(Chat, id)

  @doc """
  Creates a chat.

  ## Examples

      iex> create_chat(%{field: value})
      {:ok, %Chat{}}

      iex> create_chat(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_chat(attrs \\ %{}) do
    %Chat{}
    |> Chat.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a chat.

  ## Examples

      iex> update_chat(chat, %{field: new_value})
      {:ok, %Chat{}}

      iex> update_chat(chat, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_chat(%Chat{} = chat, attrs) do
    chat
    |> Chat.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a Chat.

  ## Examples

      iex> delete_chat(chat)
      {:ok, %Chat{}}

      iex> delete_chat(chat)
      {:error, %Ecto.Changeset{}}

  """
  def delete_chat(%Chat{} = chat) do
    Repo.delete(chat)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking chat changes.

  ## Examples

      iex> change_chat(chat)
      %Ecto.Changeset{source: %Chat{}}

  """
  def change_chat(%Chat{} = chat) do
    Chat.changeset(chat, %{})
  end
end
