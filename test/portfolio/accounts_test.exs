defmodule Portfolio.AccountsTest do
  use Portfolio.DataCase

  alias Portfolio.Accounts

  describe "user_providers" do
    alias Portfolio.Accounts.UserProvider

    @valid_email Application.fetch_env!(:portfolio, :accepted_user_email)

    @create_user_attrs %{email: @valid_email, username: "some name", picture: "some picture"}

    @valid_attrs %{provider: "some provider", uid: "some uid", user_id: "some user_id"}
    @update_attrs %{provider: "some updated provider", uid: "some updated uid"}
    @invalid_attrs %{provider: nil, uid: nil, user_id: nil}

    def user_provider_fixture(attrs \\ %{}) do
      {:ok, user} = Accounts.create_user(@create_user_attrs)
      provider_attrs = %{@valid_attrs | user_id: user.id}
      {:ok, user_provider} =
        attrs
        |> Enum.into(provider_attrs)
        |> Accounts.create_user_provider()

      user_provider
    end

    test "list_user_providers/0 returns all user_providers" do
      user_provider = user_provider_fixture()
      assert Accounts.list_user_providers() == [user_provider]
    end

    test "get_user_provider!/1 returns the user_provider with given id" do
      user_provider = user_provider_fixture()
      assert Accounts.get_user_provider!(user_provider.id) == user_provider
    end

    test "create_user_provider/1 with valid data creates a user_provider" do
      {:ok, user} = Accounts.create_user(@create_user_attrs)
      assert {:ok, %UserProvider{} = user_provider} = Accounts.create_user_provider(%{@valid_attrs | user_id: user.id})
      assert user_provider.provider == "some provider"
      assert user_provider.uid == "some uid"
      assert user_provider.user_id == user.id
    end

    test "create_user_provider/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Accounts.create_user_provider(@invalid_attrs)
    end

    test "update_user_provider/2 with valid data updates the user_provider" do
      user_provider = user_provider_fixture()
      assert {:ok, %UserProvider{} = user_provider} = Accounts.update_user_provider(user_provider, @update_attrs)
      assert user_provider.provider == "some updated provider"
      assert user_provider.uid == "some updated uid"
    end

    test "update_user_provider/2 with invalid data returns error changeset" do
      user_provider = user_provider_fixture()
      assert {:error, %Ecto.Changeset{}} = Accounts.update_user_provider(user_provider, @invalid_attrs)
      assert user_provider == Accounts.get_user_provider!(user_provider.id)
    end

    test "delete_user_provider/1 deletes the user_provider" do
      user_provider = user_provider_fixture()
      assert {:ok, %UserProvider{}} = Accounts.delete_user_provider(user_provider)
      assert_raise Ecto.NoResultsError, fn -> Accounts.get_user_provider!(user_provider.id) end
    end

    test "change_user_provider/1 returns a user_provider changeset" do
      user_provider = user_provider_fixture()
      assert %Ecto.Changeset{} = Accounts.change_user_provider(user_provider)
    end
  end
end
