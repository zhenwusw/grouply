defmodule Grouply.Reloader.ErrorHandler do
  def undefined_function(module, fun, args) do
    ensure_loaded(module)
    :error_handler.undefined_function(module, fun, args)
  end

  def undefined_lambda(module, fun, args) do
    ensure_loaded(module)
    :error_handler.undefined_lambda(module, fun, args)
  end

  defp ensure_loaded(module) do
    if Process.whereis(:code_server) do
      case Code.ensure_loaded(module) do
        { :module, _ } -> :ok
        { :error, _ }  -> Grouply.Reloader.load_missing(module)
      end

    end
  end
end
