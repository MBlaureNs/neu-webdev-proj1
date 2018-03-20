defmodule RowgameWeb.MoveControllerTest do
  use RowgameWeb.ConnCase

  alias Rowgame.Lobby
  alias Rowgame.Lobby.Move

  @create_attrs %{turn: 42, x_pos: 42, y_pos: 42}
  @update_attrs %{turn: 43, x_pos: 43, y_pos: 43}
  @invalid_attrs %{turn: nil, x_pos: nil, y_pos: nil}

  def fixture(:move) do
    {:ok, move} = Lobby.create_move(@create_attrs)
    move
  end

  setup %{conn: conn} do
    {:ok, conn: put_req_header(conn, "accept", "application/json")}
  end

  describe "index" do
    test "lists all moves", %{conn: conn} do
      conn = get conn, move_path(conn, :index)
      assert json_response(conn, 200)["data"] == []
    end
  end

  describe "create move" do
    test "renders move when data is valid", %{conn: conn} do
      conn = post conn, move_path(conn, :create), move: @create_attrs
      assert %{"id" => id} = json_response(conn, 201)["data"]

      conn = get conn, move_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "turn" => 42,
        "x_pos" => 42,
        "y_pos" => 42}
    end

    test "renders errors when data is invalid", %{conn: conn} do
      conn = post conn, move_path(conn, :create), move: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "update move" do
    setup [:create_move]

    test "renders move when data is valid", %{conn: conn, move: %Move{id: id} = move} do
      conn = put conn, move_path(conn, :update, move), move: @update_attrs
      assert %{"id" => ^id} = json_response(conn, 200)["data"]

      conn = get conn, move_path(conn, :show, id)
      assert json_response(conn, 200)["data"] == %{
        "id" => id,
        "turn" => 43,
        "x_pos" => 43,
        "y_pos" => 43}
    end

    test "renders errors when data is invalid", %{conn: conn, move: move} do
      conn = put conn, move_path(conn, :update, move), move: @invalid_attrs
      assert json_response(conn, 422)["errors"] != %{}
    end
  end

  describe "delete move" do
    setup [:create_move]

    test "deletes chosen move", %{conn: conn, move: move} do
      conn = delete conn, move_path(conn, :delete, move)
      assert response(conn, 204)
      assert_error_sent 404, fn ->
        get conn, move_path(conn, :show, move)
      end
    end
  end

  defp create_move(_) do
    move = fixture(:move)
    {:ok, move: move}
  end
end
