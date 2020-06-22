defmodule NosbyteProxy.Worker do
  @moduledoc """
  TODO: Documentation
  """

  require Logger

  @doc false
  def child_spec(_opts) do
    listener_name = __MODULE__
    num_acceptors = Application.fetch_env!(:nosbyte_proxy, :num_acceptors)
    transport = :ranch_tcp
    port = Confex.fetch_env!(:nosbyte_proxy, :port)
    transport_opts = [port: port]
    protocol = NosbyteProxy.Protocol
    backends = Confex.fetch_env!(:nosbyte_proxy, :backends)
    protocol_opts = [backends: backends]

    Logger.info("Proxy server started on port #{port}")
    Logger.info("Backends: #{inspect(backends)}")

    :ranch.child_spec(
      listener_name,
      num_acceptors,
      transport,
      transport_opts,
      protocol,
      protocol_opts
    )
  end
end
