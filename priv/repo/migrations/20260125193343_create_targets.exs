defmodule Apology.Repo.Migrations.CreateTargets do
  use Ecto.Migration

  def change do
    create table(:targets) do
      add :name, :string, null: false
      add :slug, :string, null: false
      add :title, :string
      add :organization, :string
      add :photo_url, :string
      add :bio, :text

      timestamps(type: :utc_datetime)
    end

    create unique_index(:targets, [:slug])
  end
end
