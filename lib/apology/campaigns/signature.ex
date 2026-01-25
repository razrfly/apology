defmodule Apology.Campaigns.Signature do
  @moduledoc """
  Signature schema - users signing an initiative.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "signatures" do
    field :display_name, :string
    field :comment, :string
    field :is_anonymous, :boolean, default: false
    field :verified, :boolean, default: false

    belongs_to :initiative, Apology.Campaigns.Initiative
    belongs_to :user, Apology.Accounts.User

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(signature, attrs) do
    signature
    |> cast(attrs, [:display_name, :comment, :is_anonymous, :verified, :initiative_id, :user_id])
    |> validate_required([:initiative_id])
    |> foreign_key_constraint(:initiative_id)
    |> foreign_key_constraint(:user_id)
    |> unique_constraint([:initiative_id, :user_id],
      name: :signatures_initiative_id_user_id_index,
      message: "has already signed this initiative"
    )
  end
end
