defmodule EtheroscopeWeb.PageController do
  use EtheroscopeWeb, :controller

  def index(conn, _params) do
    render conn, "index.html"
  end
end
