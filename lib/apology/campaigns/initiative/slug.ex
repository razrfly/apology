defmodule Apology.Campaigns.Initiative.Slug do
  @moduledoc """
  Slug generation for initiatives using their title.
  """
  use EctoAutoslugField.Slug, to: :slug

  import Ecto.Query

  alias Apology.Repo
  alias Apology.Campaigns.Initiative

  def get_sources(_changeset, _opts), do: [:title]

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
        from i in Initiative, where: i.slug == ^candidate and i.id != ^id
      else
        from i in Initiative, where: i.slug == ^candidate
      end

    case Repo.exists?(query) do
      true -> ensure_unique(slug, id, attempt + 1)
      false -> candidate
    end
  end
end
