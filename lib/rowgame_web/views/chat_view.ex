defmodule RowgameWeb.ChatView do
  use RowgameWeb, :view
  alias RowgameWeb.ChatView

  def render("index.json", %{chats: chats}) do
    %{data: render_many(chats, ChatView, "chat.json")}
  end

  def render("show.json", %{chat: chat}) do
    %{data: render_one(chat, ChatView, "chat.json")}
  end

  def render("chat.json", %{chat: chat}) do
    %{id: chat.id,
      time: chat.time,
      message: chat.message}
  end
end
