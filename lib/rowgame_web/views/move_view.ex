defmodule RowgameWeb.MoveView do
  use RowgameWeb, :view
  alias RowgameWeb.MoveView

  def render("index.json", %{moves: moves}) do
    %{data: render_many(moves, MoveView, "move.json")}
  end

  def render("show.json", %{move: move}) do
    %{data: render_one(move, MoveView, "move.json")}
  end

  def render("move.json", %{move: move}) do
    %{id: move.id,
      turn: move.turn,
      x_pos: move.x_pos,
      y_pos: move.y_pos}
  end
end
