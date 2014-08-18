defmodule Grouply do
  require Logger

  def start do
    Logger.info "Starting Grouply with Cowboy on http://localhost:4000"
    Plug.Adapters.Cowboy.http Grouply.Router, []
  end
end
