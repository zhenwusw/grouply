defmodule Grouply do
  require Logger

  def start(_type,_args) do
    Logger.info "Starting Grouply with Cowboy on http://localhost:4000"
    Plug.Adapters.Cowboy.http Router, []

    Grouply.Reloader.start_link
    Grouply.Reloader.enable

    { :ok, self }
  end
end

