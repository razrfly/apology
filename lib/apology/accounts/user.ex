defmodule Apology.Accounts.User do
  @moduledoc """
  User schema for Clerk-authenticated users.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "users" do
    field :clerk_id, :string
    field :email, :string
    field :display_name, :string
    field :avatar_url, :string

    has_many :initiatives, Apology.Campaigns.Initiative, foreign_key: :created_by_id
    has_many :signatures, Apology.Campaigns.Signature

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(user, attrs) do
    user
    |> cast(attrs, [:clerk_id, :email, :display_name, :avatar_url])
    |> validate_required([:clerk_id, :email])
    |> unique_constraint(:clerk_id)
    |> unique_constraint(:email)
  end
end
