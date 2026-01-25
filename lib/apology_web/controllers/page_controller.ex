defmodule ApologyWeb.PageController do
  use ApologyWeb, :controller

  alias Apology.Campaigns

  def home(conn, _params) do
    initiatives = Campaigns.list_public_initiatives()

    conn
    |> assign(:initiatives, initiatives)
    |> render(:home)
  end
end
