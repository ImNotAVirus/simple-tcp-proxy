defmodule ProxyEx.Protocol do
  @moduledoc """
  TODO: Documentation
  """

  @behaviour :ranch_protocol

  require Logger

  @doc false
  @spec start_link(reference(), pid(), atom(), keyword()) :: {:ok, pid()}
  def start_link(ref, socket, transport, opts) do
    backends = Keyword.fetch!(opts, :backends)
    pid = :proc_lib.spawn_link(__MODULE__, :init, [ref, socket, transport, backends])
    {:ok, pid}
  end

  @doc false
  @spec init(reference(), pid(), atom(), [{String.t(), non_neg_integer()}, ...]) :: any
  def init(ref, client_socket, transport, backends) do
    {:ok, {client_ip, client_port}} = :inet.peername(client_socket)
    client_name = "#{:inet.ntoa(client_ip)}:#{client_port}"

    Logger.info("New connection: #{client_name}")

    {backend_ip, backend_port} = Enum.random(backends)
    backend_name = "#{backend_ip}:#{backend_port}"
    {:ok, backend_socket} = :gen_tcp.connect(backend_ip, backend_port, [:binary, active: true])

    Logger.info("#{client_name} is now connected to #{backend_name}")

    :ok = :ranch.accept_ack(ref)
    :ok = transport.setopts(client_socket, [{:active, true}])

    state = %{
      client_name: client_name,
      client_socket: client_socket,
      backend_name: backend_name,
      backend_socket: backend_socket,
      transport: transport
    }

    :gen_server.enter_loop(__MODULE__, [], state)
  end

  ## GenServer handlers

  @doc false
  def handle_info({:tcp, socket, data}, state = %{backend_socket: backend})
      when socket == backend do
    %{
      backend_name: backend_name,
      client_name: client_name,
      client_socket: client_socket,
      transport: transport
    } = state

    size = byte_size(data)
    Logger.debug("#{size} bytes received from the backend (#{backend_name} -> #{client_name})")

    transport.send(client_socket, data)
    {:noreply, state}
  end

  @doc false
  def handle_info({:tcp, _socket, data}, state) do
    %{
      backend_name: backend_name,
      client_name: client_name,
      backend_socket: backend_socket
    } = state

    size = byte_size(data)
    Logger.debug("#{size} bytes received from the client (#{client_name} -> #{backend_name})")

    :gen_tcp.send(backend_socket, data)
    {:noreply, state}
  end

  @doc false
  def handle_info({:tcp_closed, socket}, state) do
    %{
      client_name: client_name,
      client_socket: client_socket,
      backend_socket: backend_socket,
      transport: transport
    } = state

    reason = if socket == client_socket, do: "client", else: "server"
    Logger.info("#{client_name} is now disconnected (reason: #{reason} disconnection)")

    transport.close(client_socket)
    :gen_tcp.close(backend_socket)

    {:stop, :normal, state}
  end
end
