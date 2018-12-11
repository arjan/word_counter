defmodule WordCounter.Handler do
  use GenServer
  require Logger

  @behaviour :ranch_protocol

  # http://blog.oestrich.org/2017/07/using-ranch-with-elixir

  def start_link(ref, socket, transport, opts) do
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport])
    {:ok, pid}
  end

  def init(ref, socket, transport) do
    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(socket, [{:active, true}])
    :gen_server.enter_loop(__MODULE__, [], %{socket: socket, transport: transport})
  end

  def handle_info({:tcp, _port, "STOP\n"}, state) do
    state.transport.send(state.socket, "Bye\n")
    state.transport.close(state.socket)
    Logger.info("byebye")
    {:stop, :normal, state}
  end

  def handle_info({:tcp, _port, message}, state) do
    Logger.info("Got TCP data: #{inspect(message)}")
    # bounce it back
    state.transport.send(state.socket, String.reverse(String.trim(message)) <> "\n")
    {:noreply, state}
  end

  def handle_info(message, state) do
    Logger.warn("message #{inspect(message)}")

    {:noreply, state}
  end
end
