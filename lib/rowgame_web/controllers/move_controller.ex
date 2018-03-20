defmodule RowgameWeb.MoveController do
  use RowgameWeb, :controller

  alias Rowgame.Lobby
  alias Rowgame.Lobby.Move

  action_fallback RowgameWeb.FallbackController

  def index(conn, _params) do
    moves = Lobby.list_moves()
    render(conn, "index.json", moves: moves)
  end

  def create(conn, %{"move" => move_params}) do
    with {:ok, %Move{} = move} <- Lobby.create_move(move_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", move_path(conn, :show, move))
      |> render("show.json", move: move)
    end
  end

  def show(conn, %{"id" => id}) do
    move = Lobby.get_move!(id)
    render(conn, "show.json", move: move)
  end

  def update(conn, %{"id" => id, "move" => move_params}) do
    move = Lobby.get_move!(id)

    with {:ok, %Move{} = move} <- Lobby.update_move(move, move_params) do
      render(conn, "show.json", move: move)
    end
  end

  def delete(conn, %{"id" => id}) do
    move = Lobby.get_move!(id)
    with {:ok, %Move{}} <- Lobby.delete_move(move) do
      send_resp(conn, :no_content, "")
    end
  end
end
