defmodule Apology.Campaigns.Initiative do
  @moduledoc """
  Initiative schema - campaigns demanding apologies.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Apology.Campaigns.Initiative.Slug

  schema "initiatives" do
    field :title, :string
    field :slug, Slug.Type
    field :tagline, :string
    field :description, :string
    field :demand_summary, :string
    field :image_url, :string
    field :signature_goal, :integer, default: 10000
    field :status, :string, default: "active"
    field :demand_type, :string, default: "public_apology"
    field :visibility, :string, default: "public"

    belongs_to :created_by, Apology.Accounts.User
    has_many :grievances, Apology.Campaigns.Grievance
    has_many :signatures, Apology.Campaigns.Signature
    many_to_many :targets, Apology.Campaigns.Target,
      join_through: Apology.Campaigns.InitiativeTarget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(initiative, attrs) do
    initiative
    |> cast(attrs, [
      :title, :tagline, :description, :demand_summary, :image_url,
      :signature_goal, :status, :demand_type, :visibility, :created_by_id
    ])
    |> validate_required([:title])
    |> validate_inclusion(:status, ~w(draft active paused completed))
    |> validate_inclusion(:demand_type, ~w(public_apology private_apology))
    |> validate_inclusion(:visibility, ~w(public private unlisted))
    |> Slug.maybe_generate_slug()
    |> Slug.unique_constraint()
  end
end
