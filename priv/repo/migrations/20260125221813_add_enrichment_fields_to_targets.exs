defmodule Apology.Repo.Migrations.AddEnrichmentFieldsToTargets do
  use Ecto.Migration

  def change do
    alter table(:targets) do
      add :wikipedia_title, :string
      add :logo_slug, :string
    end
  end
end
