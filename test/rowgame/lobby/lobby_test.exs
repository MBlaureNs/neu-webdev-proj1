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

  describe "chats" do
    alias Rowgame.Lobby.Chat

    @valid_attrs %{message: "some message", time: "2010-04-17 14:00:00.000000Z"}
    @update_attrs %{message: "some updated message", time: "2011-05-18 15:01:01.000000Z"}
    @invalid_attrs %{message: nil, time: nil}

    def chat_fixture(attrs \\ %{}) do
      {:ok, chat} =
        attrs
        |> Enum.into(@valid_attrs)
        |> Lobby.create_chat()

      chat
    end

    test "list_chats/0 returns all chats" do
      chat = chat_fixture()
      assert Lobby.list_chats() == [chat]
    end

    test "get_chat!/1 returns the chat with given id" do
      chat = chat_fixture()
      assert Lobby.get_chat!(chat.id) == chat
    end

    test "create_chat/1 with valid data creates a chat" do
      assert {:ok, %Chat{} = chat} = Lobby.create_chat(@valid_attrs)
      assert chat.message == "some message"
      assert chat.time == DateTime.from_naive!(~N[2010-04-17 14:00:00.000000Z], "Etc/UTC")
    end

    test "create_chat/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Lobby.create_chat(@invalid_attrs)
    end

    test "update_chat/2 with valid data updates the chat" do
      chat = chat_fixture()
      assert {:ok, chat} = Lobby.update_chat(chat, @update_attrs)
      assert %Chat{} = chat
      assert chat.message == "some updated message"
      assert chat.time == DateTime.from_naive!(~N[2011-05-18 15:01:01.000000Z], "Etc/UTC")
    end

    test "update_chat/2 with invalid data returns error changeset" do
      chat = chat_fixture()
      assert {:error, %Ecto.Changeset{}} = Lobby.update_chat(chat, @invalid_attrs)
      assert chat == Lobby.get_chat!(chat.id)
    end

    test "delete_chat/1 deletes the chat" do
      chat = chat_fixture()
      assert {:ok, %Chat{}} = Lobby.delete_chat(chat)
      assert_raise Ecto.NoResultsError, fn -> Lobby.get_chat!(chat.id) end
    end

    test "change_chat/1 returns a chat changeset" do
      chat = chat_fixture()
      assert %Ecto.Changeset{} = Lobby.change_chat(chat)
    end
  end
end
