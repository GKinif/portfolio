defmodule Portfolio.Accounts.User do
  use Ecto.Schema
  use Pow.Ecto.Schema
  use PowAssent.Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    has_many :user_identities,
             Portfolio.Accounts.UserIdentity,
      on_delete: :delete_all,
      foreign_key: :user_id

    field :name, :string
    field :picture, :string
    field :preferred_username, :string, virtual: true

    pow_user_fields()

    timestamps()
  end

  def user_identity_changeset(user_or_changeset, user_identity, attrs, user_id_attrs) do
    user_or_changeset
    |> cast(attrs, [:name, :preferred_username, :picture])
    |> pow_assent_user_identity_changeset(user_identity, attrs, user_id_attrs)
    |> validate_format(:email, ~r/@collibra.com$/)
    |> retrieve_name
  end

  defp retrieve_name(changeset) do
    name = get_change(changeset, :name)
    preferred_username = get_change(changeset, :preferred_username)

    username = if (!is_nil(preferred_username)), do: preferred_username, else: name

    put_change(changeset, :name, username)
  end
end
