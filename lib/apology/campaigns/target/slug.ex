defmodule Apology.Campaigns.Target.Slug do
  @moduledoc """
  Slug generation for targets using their name.
  """
  use EctoAutoslugField.Slug, to: :slug

  import Ecto.Query

  alias Apology.Repo
  alias Apology.Campaigns.Target

  def get_sources(_changeset, _opts), do: [:name]

  def build_slug(sources, changeset) do
    sources
    |> super(changeset)
    |> ensure_unique(changeset)
  end

  defp ensure_unique(slug, changeset) do
    id = Ecto.Changeset.get_field(changeset, :id)
    ensure_unique(slug, id, 0)
  end

  defp ensure_unique(slug, id, attempt) do
    candidate = if attempt == 0, do: slug, else: "#{slug}-#{attempt}"

    query =
      if id do
        from t in Target, where: t.slug == ^candidate and t.id != ^id
      else
        from t in Target, where: t.slug == ^candidate
      end

    case Repo.exists?(query) do
      true -> ensure_unique(slug, id, attempt + 1)
      false -> candidate
    end
  end
end
