# This file is responsible for configuring your application
# and its dependencies with the aid of the Mix.Config module.
#
# This configuration file is loaded before any dependency and
# is restricted to this project.

# General application configuration
use Mix.Config

config :portfolio,
  ecto_repos: [Portfolio.Repo]

# Configures the endpoint
config :portfolio, PortfolioWeb.Endpoint,
  url: [host: "localhost"],
  secret_key_base: "xjXurw1w33UWwVfZl9v6ExO9jTY7mBlyP9e/xMISqLFzv6JCEB6v7NxDdVMHkCdZ",
  render_errors: [view: PortfolioWeb.ErrorView, accepts: ~w(html json), layout: false],
  pubsub_server: Portfolio.PubSub,
  live_view: [signing_salt: "4ef3eHV7"]

# Configures Elixir's Logger
config :logger, :console,
  format: "$time $metadata[$level] $message\n",
  metadata: [:request_id]

# Use Jason for JSON parsing in Phoenix
config :phoenix, :json_library, Jason

config :ueberauth, Ueberauth,
  providers: [
    github: {Ueberauth.Strategy.Github, [default_scope: "user:email", send_redirect_uri: false]}
  ]

config :waffle,
  storage: Waffle.Storage.Local

# Import environment specific config. This must remain at the bottom
# of this file so it overrides the configuration defined above.
import_config "#{Mix.env()}.exs"
