defmodule Apology.Repo.Migrations.CreateInitiativeTargets do
  use Ecto.Migration

  def change do
    create table(:initiative_targets) do
      add :initiative_id, references(:initiatives, on_delete: :delete_all), null: false
      add :target_id, references(:targets, on_delete: :delete_all), null: false
      add :position, :integer, default: 0

      timestamps(type: :utc_datetime)
    end

    create index(:initiative_targets, [:initiative_id])
    create index(:initiative_targets, [:target_id])
    create unique_index(:initiative_targets, [:initiative_id, :target_id])
  end
end
