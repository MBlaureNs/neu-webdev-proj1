defmodule Rowgame.Game do
  alias Rowgame.Lobby

  def move_view(moves) do
    moves
    |> Enum.map(fn(m) ->
      %{
	"x" => m.x_pos,
	"y" => m.y_pos,
	"turn" => m.turn}
    end)
  end

  def chat_view(chats) do
    chats
    |> Enum.map(fn(m) ->
      %{
	"user_id" => m.user_id,
	"time" => m.time,
	"message" => m.message}
    end)
  end
  
  def client_view(game_id) do
    game = Lobby.get_game(game_id)
    %{
      "game_id" => game_id,
      "host_id" => game.host_id,
      "host_name" => game.host.username,
      "client_id" => game.client_id,
      "client_name" => if is_nil(game.client) do "None" else game.client.username end,
      "board_size" => game.board_size,
      "win_length" => game.win_length,
      "cur_turn" => game.cur_turn,
      "is_started" => game.is_started,
      "is_finished" => game.is_finished,
      "winner_id" => game.winner_id,
      "move" => game.move |> move_view,
      "chat" => game.chat |> chat_view,
    }
  end
  
  def join(game_id, client) do
    game = Lobby.get_game(game_id)
    Lobby.update_game(game, %{"client_id" => client})
    client_view(game_id)
  end

  def start(game_id) do
    game = Lobby.get_game(game_id)
    Lobby.update_game(game, %{"is_started" => true})
    client_view(game_id)
  end

  def click(game_id, x, y, turn) do
    game = Lobby.get_game(game_id)
    Lobby.create_move(%{
	  "x_pos" => x,
	  "y_pos" => y,
	  "turn" => turn,
	  "game_id" => game_id})
    {game_id, _} = game_id |> Integer.parse
    moves = Lobby.list_moves_from_game(game_id)
    IO.inspect(moves)
    Lobby.update_game(game, %{"cur_turn" => game.cur_turn + 1})
    client_view(game_id)
  end
end
