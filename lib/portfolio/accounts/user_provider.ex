defmodule Portfolio.Accounts.UserProvider do
  use Ecto.Schema
  import Ecto.Changeset
  alias Portfolio.Accounts.User

  schema "user_providers" do
    field :provider, :string
    field :uid, :string

    belongs_to :user, User

    timestamps()
  end

  @doc false
  def changeset(user_provider, attrs) do
    user_provider
    |> cast(attrs, [:provider, :uid, :user_id])
    |> validate_required([:provider, :uid, :user_id])
  end
end
