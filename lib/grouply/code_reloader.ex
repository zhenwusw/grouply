defmodule Grouply.CodeReloader do
  require Logger

  def init(opts), do: opts

  def call(conn, _opts) do
    Logger.info "Reloading code ..."
    if Code.ensure_loaded?(Mix.Task) do
      Mix.Task.reenable "compile.elixir"
      Mix.Task.run "compile.elixir", ["lib"]
    else
      raise """
      If you want to use the code reload plug in production or inside an escript,
      add :mix to your list of dependencies or disable code reloading"
      """
    end

    conn
  end
end
