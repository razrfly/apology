defmodule Apology.Repo.Migrations.CreateInitiatives do
  use Ecto.Migration

  def change do
    create table(:initiatives) do
      add :title, :string, null: false
      add :slug, :string, null: false
      add :tagline, :string
      add :description, :text
      add :demand_summary, :text
      add :image_url, :string
      add :signature_goal, :integer, default: 10000
      add :status, :string, default: "active"
      # Future-proofing for private apologies
      add :demand_type, :string, default: "public_apology"
      add :visibility, :string, default: "public"
      add :created_by_id, references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create unique_index(:initiatives, [:slug])
    create index(:initiatives, [:status])
    create index(:initiatives, [:visibility])
    create index(:initiatives, [:created_by_id])
  end
end
