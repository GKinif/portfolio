# In this file, we load production configuration and secrets
# from environment variables. You can also hardcode secrets,
# although such is generally not recommended and you have to
# remember to add this file to your .gitignore.
# import Config
use Mix.Config

database_url =
  System.get_env("DATABASE_URL") ||
    raise """
    environment variable DATABASE_URL is missing.
    For example: ecto://USER:PASS@HOST/DATABASE
    """

config :portfolio, Portfolio.Repo,
  # ssl: true,
  url: database_url,
  pool_size: String.to_integer(System.get_env("POOL_SIZE") || "10")

secret_key_base =
  System.get_env("SECRET_KEY_BASE") ||
    raise """
    environment variable SECRET_KEY_BASE is missing.
    You can generate one by calling: mix phx.gen.secret
    """

config :portfolio, PortfolioWeb.Endpoint,
  http: [
    port: String.to_integer(System.get_env("PORT") || "4000"),
    transport_options: [socket_opts: [:inet6]]
  ],
  secret_key_base: secret_key_base

github_client_id =
  System.get_env("GITHUB_CLIENT_ID") ||
    raise """
    environment variable GITHUB_CLIENT_ID is missing.
    """

github_client_secret =
  System.get_env("GITHUB_CLIENT_SECRET") ||
    raise """
    environment variable GITHUB_CLIENT_SECRET is missing.
    """

config :ueberauth, Ueberauth.Strategy.Github.OAuth,
  client_id: github_client_id,
  client_secret: github_client_secret

accepted_user_email =
  System.get_env("ACCEPTED_USER_EMAIL") ||
    raise """
    environment variable ACCEPTED_USER_EMAIL is missing.
    provide a list of accepted user email separated by a space
    """

config :portfolio,
  accepted_user_email: accepted_user_email

storage_dir =
  System.get_env("STORAGE_DIR") ||
    raise """
    environment variable STORAGE_DIR is missing.
    """
config :waffle,
       storage_dir: storage_dir

# ## Using releases (Elixir v1.9+)
#
# If you are doing OTP releases, you need to instruct Phoenix
# to start each relevant endpoint:
#
config :portfolio, PortfolioWeb.Endpoint, server: true
#
# Then you can assemble a release by calling `mix release`.
# See `mix help release` for more information.
