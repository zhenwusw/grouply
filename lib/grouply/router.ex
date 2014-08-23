defmodule Grouply.Router do
  import Plug.Conn
  use Plug.Router

  plug :match
  plug :dispatch
  plug Grouply.CodeReloader

  get "/index" do
    tmpl = EEx.eval_file "priv/templates/index.html", assigns: [title: 'Grouply']
    send_resp(conn, 200, tmpl)
  end

  match _ do
    send_resp(conn, 404, "oops")
  end
end
