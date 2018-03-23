# adapted from nat's notes
# http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/12-microblog/notes.html

defmodule RowgameWeb.SessionController do
  use RowgameWeb, :controller

  alias Rowgame.Accounts

  def create(conn, %{"username" => username}) do
    user = Accounts.get_user_by_username(username)
    if user do
      conn
      |> put_session(:user_id, user.id)
      |> put_flash(:info, "Welcome, #{user.username}")
      |> redirect(to: game_path(conn, :index))
    else
      conn
      |> put_flash(:error, "Can't create session")
      |> redirect(to: page_path(conn, :index))
    end
  end

  def delete(conn, _params) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out")
    |> redirect(to: page_path(conn, :index))
  end
end
