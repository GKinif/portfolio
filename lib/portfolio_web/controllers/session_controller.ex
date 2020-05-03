defmodule PortfolioWeb.SessionController do
  use PortfolioWeb, :controller
  alias Portfolio.Accounts

  plug Ueberauth

  def new(conn, _) do
    render(conn, "new.html")
  end

  def delete(conn, _) do
    conn
    |> delete_session(:user_id)
    |> put_flash(:info, "Logged out successfully!")
    |> redirect(to: "/")
  end

  # =================
  # === Ueberauth ===
  # =================

  def callback(%{assigns: %{ueberauth_failure: _fails}} = conn, _params) do
    conn
    |> put_flash(:error, "Failed to authenticate")
    |> redirect(to: "/")
  end

  def callback(%{assigns: %{ueberauth_auth: auth}} = conn, _params) do
    case find_or_create_user(auth) do
      {:ok, user} ->
        conn
        |> put_flash(:info, "Logged in successfully!")
        |> put_session(:user_id, user.id)
        |> redirect(to: "/")

      {:error, reason} ->
        conn
        |> put_flash(:error, reason)
        |> redirect(to: "/")
    end
  end

  defp find_or_create_user(auth) do
    auth_data = extract_data_from_auth(auth)
    IO.puts("AUTH DATA")
    IO.inspect(auth_data)

    case Accounts.get_user_provider_by_oauth(auth_data.provider, auth_data.uid) do
      nil ->
        case Accounts.get_user_by_email(auth_data.email) do
          nil ->
            with {:ok, user} <- Accounts.create_user_from_provider(auth_data, auth_data) do
              user
            else
              error -> error
            end
          _ -> {:error, "Email already exist"}
        end

      user_provider ->
        {:ok, user_provider.user}
    end
  end

  defp extract_data_from_auth(%{provider: :github} = auth) do
    %{
      uid: to_string(auth.uid),
      provider: "github",
      email: auth.info.email,
      username: auth.info.name,
      picture: auth.info.urls.avatar_url
    }
  end
end