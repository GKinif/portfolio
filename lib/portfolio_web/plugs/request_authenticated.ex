defmodule PortfolioWeb.Plugs.RequestAuthenticated do
  import Plug.Conn, only: [get_session: 2, halt: 1, assign: 3]
  import Phoenix.Controller, only: [put_flash: 3, redirect: 2]

  def init(opts), do: opts

  def call(conn, _opts) do
    case get_session(conn, :user_id) do
      nil ->
        conn
        |> assign(:user_token, nil)
        |> put_flash(:error, "You must be logged in to execute this action!")
        |> redirect(to: "/")
        |> halt()

      user_id ->
        token = Phoenix.Token.sign(conn, "user socket", user_id)
        conn
        |> assign(:user_token, token)
    end
  end
end
