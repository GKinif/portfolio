defmodule PortfolioWeb.Plugs.RequestAuthenticatedApi do
  import Plug.Conn, only: [get_session: 2, halt: 1, assign: 3, send_resp: 3]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> assign(:user_token, nil)
        |> send_resp(401, "Authentication required")
        |> halt()

      user_id ->
        token = Phoenix.Token.sign(conn, "user socket", user_id)
        conn
        |> assign(:user_token, token)
    end
  end
end
