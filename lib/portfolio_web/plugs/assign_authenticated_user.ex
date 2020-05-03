defmodule PortfolioWeb.Plugs.AssignAuthenticatedUser do
  import Plug.Conn, only: [get_session: 2, assign: 3]

  def init(opts), do: opts

  def call(conn, _opts) do
    user =
      conn
      |> get_session(:user_id)
      |> case do
        nil -> nil
        id -> Portfolio.Accounts.get_user!(id)
      end
    assign(conn, :current_user, user)
  end
end