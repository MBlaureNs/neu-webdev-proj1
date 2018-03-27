defmodule RowgameWeb.GamesChannel do
  use RowgameWeb, :channel
  alias Rowgame.Game
  
  def join("games:" <> game_id, payload, socket) do
    if authorized?(payload) do
      {:ok, Game.client_view(game_id), socket}
    else
      {:error, %{reason: "unauthorized"}}
    end
  end

  def handle_in("click", %{"x" => x, "y" => y, "turn" => turn}, socket) do
    gid = socket.topic |> String.split(":") |> Enum.at(1);
    game = Game.click(gid, x, y, turn)
    RowgameWeb.Endpoint.broadcast(socket.topic, "update", game)
    {:reply, {:ok, game}, socket}
  end

  def handle_in("start", _, socket) do
    gid = socket.topic |> String.split(":") |> Enum.at(1);
    game = Game.start(gid)
    RowgameWeb.Endpoint.broadcast(socket.topic, "update", game)
    {:reply, {:ok, game}, socket}
  end

  def handle_in("join", %{"client" => client}, socket) do
    gid = socket.topic |> String.split(":") |> Enum.at(1);
    game = Game.join(gid, client)
    RowgameWeb.Endpoint.broadcast(socket.topic, "update", game)
    {:reply, {:ok, game}, socket}
  end

  # Add authorization logic here as required.
  defp authorized?(_payload) do
    true
  end
end
