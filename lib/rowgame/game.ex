defmodule Rowgame.Game do
  alias Rowgame.Lobby
  
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
      "move" => game.move,
      "chat" => game.chat,
    }
  end
  
  def join(game_id, client) do
    client_view(game_id)
  end

  def start(game_id) do
    client_view(game_id)
  end

  def click(game_id, x, y) do
    client_view(game_id)
  end
end
