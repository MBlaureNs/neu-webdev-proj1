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
    if is_winner(moves, x, y, turn, game.win_length) do
      if rem(turn,2) == 1 do
	Lobby.update_game(game, %{"winner_id" => game.host_id})
      else
	Lobby.update_game(game, %{"winner_id" => game.client_id})
      end
      Lobby.update_game(game, %{"is_finished" => true})
    end
    if length(moves) == game.board_size*game.board_size do
      Lobby.update_game(game, %{"is_finished" => true})
    end
    Lobby.update_game(game, %{"cur_turn" => game.cur_turn + 1})
    client_view(game_id)
  end

  def move_matches_color(moves, x, y, turn) do
    r = moves
    |> Enum.find(fn(mv) ->
      (mv.x_pos == x) and
      (mv.y_pos == y) and
      (rem(mv.turn, 2) == rem(turn,2))
    end)
    |> is_nil
    not r
  end

  def is_winner(moves, x, y, turn, win_length) do
    bi_run_length(moves, x, y,  1, 0, turn) >= win_length or
    bi_run_length(moves, x, y,  1, 1, turn) >= win_length or
    bi_run_length(moves, x, y,  0, 1, turn) >= win_length or
    bi_run_length(moves, x, y, -1, 1, turn) >= win_length 
  end
  
  def bi_run_length(moves, x, y , dx, dy, turn) do
    r = 1 + uni_run_length(moves, x, y, dx, dy, turn) + uni_run_length(moves, x, y, -dx, -dy, turn)
    r
  end
  
  def uni_run_length(moves, x, y, dx, dy, turn) do
    r = moves
    |> Enum.find(fn(mv) ->
      (mv.x_pos == x+dx) and
      (mv.y_pos == y+dy) and
      (rem(mv.turn, 2) == rem(turn,2))
    end)
    |> is_nil
    if r do
      0
    else
      1 + uni_run_length(moves, x+dx, y+dy, dx, dy, turn)
    end
  end
end
