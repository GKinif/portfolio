defmodule Portfolio.Accounts.User do
  use Ecto.Schema
  import Ecto.Changeset

  @accepted_user_email ~w(#{Application.get_env(:portfolio, :accepted_user_email)})

  schema "users" do

    has_many :user_provider, Portfolio.Accounts.UserProvider, on_delete: :delete_all

    field :username, :string
    field :email, :string
    field :picture, :string

    timestamps()
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:username, :email, :picture])
    |> validate_required([:email, :username])
    |> unique_constraint(:email)
    |> validate_inclusion(:email, @accepted_user_email)
  end
end
