use Mix.Config

config :logger, :console,
  level: :info,
  format: "$time $metadata[$level] $message\n",
  metadata: [:application]

config :proxy_ex, num_acceptors: 40
