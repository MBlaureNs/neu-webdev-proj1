defmodule RowgameWeb.Router do
  use RowgameWeb, :router

  pipeline :browser do
    plug :accepts, ["html"]
    plug :fetch_session
    plug :fetch_flash
    plug :protect_from_forgery
    plug :put_secure_browser_headers
  end

  pipeline :api do
    plug :accepts, ["json"]    
  end

  scope "/", RowgameWeb do
    pipe_through :browser # Use the default browser stack

    get "/", PageController, :index
    resources "/users", UserController
    resources "/games", GameController
  end

  scope "/api/v1", RowgameWeb do
    pipe_through :api
    resources "/moves", MoveController, except: [:new, :edit]
    resources "/chats", ChatController, except: [:new, :edit]
  end
end
