defmodule Apology.Campaigns.Grievance do
  @moduledoc """
  Grievance schema - specific complaints against targets within an initiative.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "grievances" do
    field :summary, :string
    field :description, :string
    field :evidence_url, :string
    field :severity, :string, default: "moderate"

    belongs_to :initiative, Apology.Campaigns.Initiative
    belongs_to :target, Apology.Campaigns.Target

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(grievance, attrs) do
    grievance
    |> cast(attrs, [:summary, :description, :evidence_url, :severity, :initiative_id, :target_id])
    |> validate_required([:summary, :initiative_id, :target_id])
    |> validate_inclusion(:severity, ~w(minor moderate severe critical))
    |> foreign_key_constraint(:initiative_id)
    |> foreign_key_constraint(:target_id)
  end
end
