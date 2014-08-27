defmodule Grouply.Reloader do
  require Logger
  use GenServer

  defmodule Config do
    defstruct root_path: nil, loaded_modules: [], load_time: { { 1970, 1, 1 }, { 0, 0, 0 } }
  end

  # server code
  def start_link do
    :gen_server.start({ :local, __MODULE__ }, __MODULE__, [], [])
  end

  def stop do
    :gen_server.call(__MODULE__, :stop)
  end

  def init(_args) do
    { :ok, %Config{} }
  end

  ######################################

  def enable do
    if Process.whereis(__MODULE__) do
      Process.put(:elixir_ensure_compiled, true)
      Process.flag(:error_handler, Grouply.Reloader.ErrorHandler)
      :ok
    else
      :error
    end
  end

  defp start_reloader do
    start_link
    # import Supervisor.Spec
    # spec = [worker(Grouply.Reloader, [])]
    # opts = [strategy: :one_for_one, name: Grouply.Supervisor]
    # Supervisor.start_link(spec, opts)
  end

  def purge_modules do
    :gen_server.call(__MODULE__, :purge_modules)
  end

  def load_modules do
    Path.wildcard("lib/web/**/*.ex") |> try_to_compile
  end

  defp try_to_compile([]) do
    []
  end

  defp try_to_compile([path | t]) do
    try do
      Kernel.ParallelCompiler.files([path], [])
      try_to_compile(t)
    catch
      kind, reason ->
        :erlang.raise(kind, reason, System.stacktrace)
        try_to_compile(t)
    end
  end

  # No matter if files was updated, purge all modules for now
  def handle_call(:purge_modules, _from, %Config{ loaded_modules: loaded_modules, load_time: load_time } = config) do
    purge_all(loaded_modules)
    unload_all
    { :reply, { :purged, :all }, %Config{config | loaded_modules: [] }}
  end

  defp purge_all(loaded_modules) do
    Enum.each loaded_modules, fn(mod) ->
      :code.purge(mod)
      :code.delete(mod)
    end
  end

  defp unload_all do
    files = Path.wildcard("lib/web/**/*.ex")
    Code.unload_files(files)
  end
end
