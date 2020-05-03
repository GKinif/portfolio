defmodule Portfolio.Accounts do
  import Ecto.Query, warn: false

  alias Portfolio.Repo
  alias Portfolio.Accounts.User
  alias Portfolio.Accounts.UserProvider

  @doc """
  Returns the list of users.

  ## Examples

      iex> list_users()
      [%User{}, ...]

  """
  def list_users, do: Repo.all(User)

  @doc """
  Gets a single user.

  Raises `Ecto.NoResultsError` if the User does not exist.

  ## Examples

      iex> get_user!(123)
      %User{}

      iex> get_user!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user!(id), do: Repo.get!(User, id)

  @doc """
  Gets a single user.

  ## Examples

      iex> get_user_by_email("example@email.com")
      %User{}
  """
  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  @doc """
  Creates a user.

  ## Examples

      iex> create_user(%{field: value})
      {:ok, %User{}}

      iex> create_user(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user.

  ## Examples

      iex> update_user(user, %{field: new_value})
      {:ok, %User{}}

      iex> update_user(user, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user.

  ## Examples

      iex> delete_user(user)
      {:ok, %User{}}

      iex> delete_user(user)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user(%User{} = user) do
    Repo.delete(user)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user changes.

  ## Examples

      iex> change_user(user)
      %Ecto.Changeset{data: %User{}}

  """
  def change_user(%User{} = user, attrs \\ %{}) do
    User.changeset(user, attrs)
  end

  @doc """
  Returns the total count of users
  """
  def count_user(), do: Repo.one(from u in "users", select: count(u.id))

  @doc """
  Returns the list of user_providers.

  ## Examples

      iex> list_user_providers()
      [%UserProvider{}, ...]

  """
  def list_user_providers do
    Repo.all(UserProvider)
  end

  @doc """
  Gets a single user_provider.

  Raises `Ecto.NoResultsError` if the User provider does not exist.

  ## Examples

      iex> get_user_provider!(123)
      %UserProvider{}

      iex> get_user_provider!(456)
      ** (Ecto.NoResultsError)

  """
  def get_user_provider!(id), do: Repo.get!(UserProvider, id)

  @doc """
  Gets a single user_provider.

  ## Examples

      iex> get_user_provider_by_oauth("google", "2354234")
      %UserProvider{}

  """
  def get_user_provider_by_oauth(provider, uid) do
    Repo.get_by(UserProvider, provider: provider, uid: uid) |> Repo.preload(:user)
  end

  @doc """
  Creates a user_provider.

  ## Examples

      iex> create_user_provider(%{field: value})
      {:ok, %UserProvider{}}

      iex> create_user_provider(%{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def create_user_provider(attrs \\ %{}) do
    %UserProvider{}
    |> UserProvider.changeset(attrs)
    |> Repo.insert()
  end

  @doc """
  Updates a user_provider.

  ## Examples

      iex> update_user_provider(user_provider, %{field: new_value})
      {:ok, %UserProvider{}}

      iex> update_user_provider(user_provider, %{field: bad_value})
      {:error, %Ecto.Changeset{}}

  """
  def update_user_provider(%UserProvider{} = user_provider, attrs) do
    user_provider
    |> UserProvider.changeset(attrs)
    |> Repo.update()
  end

  @doc """
  Deletes a user_provider.

  ## Examples

      iex> delete_user_provider(user_provider)
      {:ok, %UserProvider{}}

      iex> delete_user_provider(user_provider)
      {:error, %Ecto.Changeset{}}

  """
  def delete_user_provider(%UserProvider{} = user_provider) do
    Repo.delete(user_provider)
  end

  @doc """
  Returns an `%Ecto.Changeset{}` for tracking user_provider changes.

  ## Examples

      iex> change_user_provider(user_provider)
      %Ecto.Changeset{data: %UserProvider{}}

  """
  def change_user_provider(%UserProvider{} = user_provider, attrs \\ %{}) do
    UserProvider.changeset(user_provider, attrs)
  end

  def create_user_from_provider(provider_attrs, user_attrs) do
    Repo.transaction(fn ->
      with {:ok, user} <- create_user(user_attrs),
          {:ok, _user_provider} <- create_user_provider(Map.put(provider_attrs, :user_id, user.id)) do
        {:ok, user}
      else
        _ -> Repo.rollback("Invalid user")
      end
    end)
  end
end
