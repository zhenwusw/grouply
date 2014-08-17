defmodule Grouply do
  def start do
    IO.puts "Running Grouply with Cowboy on http://localhost:4000"
    Plug.Adapters.Cowboy.http Grouply.Router, []
  end
end
