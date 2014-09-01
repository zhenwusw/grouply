defmodule Repo do
  use Ecto.Repo, adapter: Ecto.Adapters.Postgres

  def conf do
    # The scheme can be anything, "ecto" is just an example
    parse_url "ecto://postgres:postgres@localhost/grouply"
  end

  def priv do
    app_dir(:grouply, "priv/repo")
  end
end

