defmodule Apology.Campaigns do
  @moduledoc """
  The Campaigns context - initiatives, targets, grievances, and signatures.
  """
  import Ecto.Query

  alias Apology.Repo
  alias Apology.Campaigns.{Initiative, Target, Grievance, Signature, InitiativeTarget}

  # Initiatives

  def list_initiatives(opts \\ []) do
    Initiative
    |> filter_by_visibility(opts[:visibility])
    |> filter_by_status(opts[:status])
    |> order_by([i], desc: i.inserted_at)
    |> Repo.all()
  end

  def list_public_initiatives do
    list_initiatives(visibility: "public", status: "active")
  end

  def get_initiative!(id), do: Repo.get!(Initiative, id)

  def get_initiative_by_slug!(slug) do
    Initiative
    |> Repo.get_by!(slug: slug)
    |> Repo.preload([:targets, :grievances])
  end

  def get_initiative_by_slug(slug) do
    case Repo.get_by(Initiative, slug: slug) do
      nil -> {:error, :not_found}
      initiative -> {:ok, Repo.preload(initiative, [:targets, :grievances])}
    end
  end

  def create_initiative(attrs \\ %{}) do
    %Initiative{}
    |> Initiative.changeset(attrs)
    |> Repo.insert()
  end

  def update_initiative(%Initiative{} = initiative, attrs) do
    initiative
    |> Initiative.changeset(attrs)
    |> Repo.update()
  end

  def get_signature_count(initiative_id) do
    Signature
    |> where([s], s.initiative_id == ^initiative_id)
    |> Repo.aggregate(:count)
  end

  # Targets

  def list_targets do
    Repo.all(Target)
  end

  def get_target!(id), do: Repo.get!(Target, id)

  def get_target_by_slug!(slug), do: Repo.get_by!(Target, slug: slug)

  def create_target(attrs \\ %{}) do
    %Target{}
    |> Target.changeset(attrs)
    |> Repo.insert()
  end

  def update_target(%Target{} = target, attrs) do
    target
    |> Target.changeset(attrs)
    |> Repo.update()
  end

  # Grievances

  def list_grievances_for_initiative(initiative_id) do
    Grievance
    |> where([g], g.initiative_id == ^initiative_id)
    |> preload(:target)
    |> Repo.all()
  end

  def create_grievance(attrs \\ %{}) do
    %Grievance{}
    |> Grievance.changeset(attrs)
    |> Repo.insert()
  end

  # Signatures

  def list_signatures_for_initiative(initiative_id, opts \\ []) do
    limit = Keyword.get(opts, :limit, 50)

    Signature
    |> where([s], s.initiative_id == ^initiative_id)
    |> order_by([s], desc: s.inserted_at)
    |> limit(^limit)
    |> Repo.all()
  end

  def create_signature(attrs \\ %{}) do
    %Signature{}
    |> Signature.changeset(attrs)
    |> Repo.insert()
  end

  def user_has_signed?(initiative_id, user_id) when is_integer(user_id) do
    Signature
    |> where([s], s.initiative_id == ^initiative_id and s.user_id == ^user_id)
    |> Repo.exists?()
  end

  def user_has_signed?(_initiative_id, nil), do: false

  # Initiative Targets

  def add_target_to_initiative(initiative_id, target_id, position \\ 0) do
    %InitiativeTarget{}
    |> InitiativeTarget.changeset(%{
      initiative_id: initiative_id,
      target_id: target_id,
      position: position
    })
    |> Repo.insert()
  end

  # Private helpers

  defp filter_by_visibility(query, nil), do: query
  defp filter_by_visibility(query, visibility) do
    where(query, [i], i.visibility == ^visibility)
  end

  defp filter_by_status(query, nil), do: query
  defp filter_by_status(query, status) do
    where(query, [i], i.status == ^status)
  end
end
