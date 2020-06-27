use Mix.Config

config :logger, :console,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:application]

config :nosbyte_proxy, num_acceptors: 40
