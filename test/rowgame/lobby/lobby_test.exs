defmodule Rowgame.LobbyTest do
  use Rowgame.DataCase

  alias Rowgame.Lobby

  describe "games" do
    alias Rowgame.Lobby.Game

    @valid_attrs %{board_size: 42, cur_turn: 42, is_finished: true, is_started: true, win_length: 42}
    @update_attrs %{board_size: 43, cur_turn: 43, is_finished: false, is_started: false, win_length: 43}
    @invalid_attrs %{board_size: nil, cur_turn: nil, is_finished: nil, is_started: nil, win_length: nil}

    def game_fixture(attrs \\ %{}) do
      {:ok, game} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lobby.create_game()

      game
    end

    test "list_games/0 returns all games" do
      game = game_fixture()
      assert Lobby.list_games() == [game]
    end

    test "get_game!/1 returns the game with given id" do
      game = game_fixture()
      assert Lobby.get_game!(game.id) == game
    end

    test "create_game/1 with valid data creates a game" do
      assert {:ok, %Game{} = game} = Lobby.create_game(@valid_attrs)
      assert game.board_size == 42
      assert game.cur_turn == 42
      assert game.is_finished == true
      assert game.is_started == true
      assert game.win_length == 42
    end

    test "create_game/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lobby.create_game(@invalid_attrs)
    end

    test "update_game/2 with valid data updates the game" do
      game = game_fixture()
      assert {:ok, game} = Lobby.update_game(game, @update_attrs)
      assert %Game{} = game
      assert game.board_size == 43
      assert game.cur_turn == 43
      assert game.is_finished == false
      assert game.is_started == false
      assert game.win_length == 43
    end

    test "update_game/2 with invalid data returns error changeset" do
      game = game_fixture()
      assert {:error, %Ecto.Changeset{}} = Lobby.update_game(game, @invalid_attrs)
      assert game == Lobby.get_game!(game.id)
    end

    test "delete_game/1 deletes the game" do
      game = game_fixture()
      assert {:ok, %Game{}} = Lobby.delete_game(game)
      assert_raise Ecto.NoResultsError, fn -> Lobby.get_game!(game.id) end
    end

    test "change_game/1 returns a game changeset" do
      game = game_fixture()
      assert %Ecto.Changeset{} = Lobby.change_game(game)
    end
  end

  describe "moves" do
    alias Rowgame.Lobby.Move

    @valid_attrs %{turn: 42, x_pos: 42, y_pos: 42}
    @update_attrs %{turn: 43, x_pos: 43, y_pos: 43}
    @invalid_attrs %{turn: nil, x_pos: nil, y_pos: nil}

    def move_fixture(attrs \\ %{}) do
      {:ok, move} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lobby.create_move()

      move
    end

    test "list_moves/0 returns all moves" do
      move = move_fixture()
      assert Lobby.list_moves() == [move]
    end

    test "get_move!/1 returns the move with given id" do
      move = move_fixture()
      assert Lobby.get_move!(move.id) == move
    end

    test "create_move/1 with valid data creates a move" do
      assert {:ok, %Move{} = move} = Lobby.create_move(@valid_attrs)
      assert move.turn == 42
      assert move.x_pos == 42
      assert move.y_pos == 42
    end

    test "create_move/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lobby.create_move(@invalid_attrs)
    end

    test "update_move/2 with valid data updates the move" do
      move = move_fixture()
      assert {:ok, move} = Lobby.update_move(move, @update_attrs)
      assert %Move{} = move
      assert move.turn == 43
      assert move.x_pos == 43
      assert move.y_pos == 43
    end

    test "update_move/2 with invalid data returns error changeset" do
      move = move_fixture()
      assert {:error, %Ecto.Changeset{}} = Lobby.update_move(move, @invalid_attrs)
      assert move == Lobby.get_move!(move.id)
    end

    test "delete_move/1 deletes the move" do
      move = move_fixture()
      assert {:ok, %Move{}} = Lobby.delete_move(move)
      assert_raise Ecto.NoResultsError, fn -> Lobby.get_move!(move.id) end
    end

    test "change_move/1 returns a move changeset" do
      move = move_fixture()
      assert %Ecto.Changeset{} = Lobby.change_move(move)
    end
  end
end
