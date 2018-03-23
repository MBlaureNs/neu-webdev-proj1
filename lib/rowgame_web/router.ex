defmodule RowgameWeb.Router do
  use RowgameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :get_current_user
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]    
  end

  # adapted from nat's notes
  # http://www.ccs.neu.edu/home/ntuck/courses/2018/01/cs4550/notes/12-microblog/notes.html
  def get_current_user(conn, _params) do
    # TODO: Move this function out of the router module.
    user_id = get_session(conn, :user_id)
    user = Rowgame.Accounts.get_user(user_id || -1)
    assign(conn, :current_user, user)
  end

  scope "/", RowgameWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/games", GameController

    post "/session", SessionController, :create
    delete "/session", SessionController, :delete
  end

  scope "/api/v1", RowgameWeb do
    pipe_through :api
    resources "/moves", MoveController, except: [:new, :edit]
    resources "/chats", ChatController, except: [:new, :edit]
  end
end
