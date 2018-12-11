defmodule WordCounter.Acceptor do
  def start_link do
    opts = [port: 8008]
    {:ok, _} = :ranch.start_listener(__MODULE__, 100, :ranch_tcp, opts, WordCounter.Handler, [])
  end
end
