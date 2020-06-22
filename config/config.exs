# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
use Mix.Config

# This configuration is loaded before any dependency and is restricted
# to this project. If another project depends on this project, this
# file won't be loaded nor affect the parent project. For this reason,
# if you want to provide default values for your application for
# third-party users, it should be done in your "mix.exs" file.

# You can configure your application as:
#
#     config :nosbyte_proxy, key: :value
#
# and access this configuration in your application as:
#
#     Application.get_env(:nosbyte_proxy, :key)
#
# You can also configure a third-party app:
#
#     config :logger, level: :info
#

# It is also possible to import configuration files, relative to this
# directory. For example, you can emulate configuration per environment
# by uncommenting the line below and defining dev.exs, test.exs and such.
# Configuration from the imported file will override the ones defined
# here (which is why it is important to import them last).
#
#     import_config "#{Mix.env()}.exs"

config :logger, :console,
  level: :debug,
  format: "$time $metadata[$level] $message\n",
  metadata: [:application]

config :nosbyte_proxy,
  num_acceptors: 10,
  port: {:system, :integer, "PORT", 3000},
  # Comma separated (eg. `10.0.0.1:4002,10.0.0.2:4002,10.0.0.3:4002`)
  backends: {:system, {NosbyteProxy.IP, :cast, []}, "BACKENDS", [{'127.0.0.1', 4002}]}
