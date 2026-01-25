defmodule Apology.Campaigns.InitiativeTarget do
  @moduledoc """
  Join schema linking initiatives to their targets.
  """
  use Ecto.Schema
  import Ecto.Changeset

  schema "initiative_targets" do
    field :position, :integer, default: 0

    belongs_to :initiative, Apology.Campaigns.Initiative
    belongs_to :target, Apology.Campaigns.Target

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(initiative_target, attrs) do
    initiative_target
    |> cast(attrs, [:position, :initiative_id, :target_id])
    |> validate_required([:initiative_id, :target_id])
    |> foreign_key_constraint(:initiative_id)
    |> foreign_key_constraint(:target_id)
    |> unique_constraint([:initiative_id, :target_id])
  end
end
