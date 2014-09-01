defmodule Helper.Partial do
  @moduledoc """
    <%= render "Partial" %>
  """

  def render(file) do
    Path.expand(file <> ".html", "priv/templates") |> EEx.eval_file
  end
end

