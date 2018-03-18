defmodule RowgameWeb.PageController do
  use RowgameWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
