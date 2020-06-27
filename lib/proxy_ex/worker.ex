defmodule ProxyEx.Worker do
  @moduledoc """
  TODO: Documentation
  """

  require Logger

  @doc false
  def child_spec(_opts) do
    listener_name = __MODULE__
    num_acceptors = Application.fetch_env!(:proxy_ex, :num_acceptors)
    transport = :ranch_tcp
    port = Confex.fetch_env!(:proxy_ex, :port)
    transport_opts = [port: port]
    protocol = ProxyEx.Protocol
    backends = Confex.fetch_env!(:proxy_ex, :backends)
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
