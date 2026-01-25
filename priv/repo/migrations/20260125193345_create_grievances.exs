defmodule Apology.Repo.Migrations.CreateGrievances do
  use Ecto.Migration

  def change do
    create table(:grievances) do
      add :summary, :string, null: false
      add :description, :text
      add :evidence_url, :string
      add :severity, :string, default: "moderate"
      add :initiative_id, references(:initiatives, on_delete: :delete_all), null: false
      add :target_id, references(:targets, on_delete: :delete_all), null: false

      timestamps(type: :utc_datetime)
    end

    create index(:grievances, [:initiative_id])
    create index(:grievances, [:target_id])
  end
end
