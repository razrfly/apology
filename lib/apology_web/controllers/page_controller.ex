defmodule ApologyWeb.PageController do
  use ApologyWeb, :controller

  alias Apology.Campaigns

  plug :put_layout, html: {ApologyWeb.Layouts, :app}

  def home(conn, _params) do
    initiatives = Campaigns.list_public_initiatives()

    conn
    |> assign(:current_path, conn.request_path)
    |> assign(:initiatives, initiatives)
    |> render(:home)
  end

  def about(conn, _params) do
    conn
    |> assign(:current_path, conn.request_path)
    |> assign(:page_title, "About")
    |> render(:about)
  end

  def story(conn, _params) do
    conn
    |> assign(:current_path, conn.request_path)
    |> assign(:page_title, "Our Story")
    |> render(:story)
  end
end
