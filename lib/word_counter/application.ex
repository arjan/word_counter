defmodule WordCounter.Application do
  use Application

  def start(_, _) do
    import Supervisor.Spec

    children = [
      worker(WordCounter.Acceptor, [])
    ]

    opts = [strategy: :one_for_one, name: BotsiCommon.Supervisor]
    Supervisor.start_link(children, opts)
  end
end
