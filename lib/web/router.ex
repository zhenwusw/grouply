defmodule Router do
  require Logger

  use Plug.Router
  import Plug.Conn

  plug Plug.Static, at: "/public", from: Path.expand("../../public/", __DIR__), gzip: true

  plug :reload_on_demand
  def reload_on_demand(conn, _opts) do
    Grouply.Reloader.purge_modules
    Grouply.Reloader.load_modules

    conn
  end

  plug :match
  plug :dispatch

  get "/" do
    tmpl = EEx.eval_file "priv/templates/index.html", assigns: [title: 'Grouply']
    send_resp(conn, 200, tmpl)
  end

  match _ do
    send_resp(conn, 404, "not found")
  end

end
