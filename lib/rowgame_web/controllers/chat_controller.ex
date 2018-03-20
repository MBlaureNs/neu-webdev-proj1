defmodule RowgameWeb.ChatController do
  use RowgameWeb, :controller

  alias Rowgame.Lobby
  alias Rowgame.Lobby.Chat

  action_fallback RowgameWeb.FallbackController

  def index(conn, _params) do
    chats = Lobby.list_chats()
    render(conn, "index.json", chats: chats)
  end

  def create(conn, %{"chat" => chat_params}) do
    with {:ok, %Chat{} = chat} <- Lobby.create_chat(chat_params) do
      conn
      |> put_status(:created)
      |> put_resp_header("location", chat_path(conn, :show, chat))
      |> render("show.json", chat: chat)
    end
  end

  def show(conn, %{"id" => id}) do
    chat = Lobby.get_chat!(id)
    render(conn, "show.json", chat: chat)
  end

  def update(conn, %{"id" => id, "chat" => chat_params}) do
    chat = Lobby.get_chat!(id)

    with {:ok, %Chat{} = chat} <- Lobby.update_chat(chat, chat_params) do
      render(conn, "show.json", chat: chat)
    end
  end

  def delete(conn, %{"id" => id}) do
    chat = Lobby.get_chat!(id)
    with {:ok, %Chat{}} <- Lobby.delete_chat(chat) do
      send_resp(conn, :no_content, "")
    end
  end
end
