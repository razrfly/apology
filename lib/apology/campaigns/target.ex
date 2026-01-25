defmodule Apology.Campaigns.Target do
  @moduledoc """
  Target schema - people/entities who should apologize.
  """
  use Ecto.Schema
  import Ecto.Changeset

  alias Apology.Campaigns.Target.Slug

  schema "targets" do
    field :name, :string
    field :slug, Slug.Type
    field :title, :string
    field :organization, :string
    field :photo_url, :string
    field :bio, :string
    field :wikipedia_title, :string
    field :logo_slug, :string

    has_many :grievances, Apology.Campaigns.Grievance
    many_to_many :initiatives, Apology.Campaigns.Initiative,
      join_through: Apology.Campaigns.InitiativeTarget

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(target, attrs) do
    target
    |> cast(attrs, [:name, :title, :organization, :photo_url, :bio, :wikipedia_title, :logo_slug])
    |> validate_required([:name])
    |> Slug.maybe_generate_slug()
    |> Slug.unique_constraint()
  end
end
