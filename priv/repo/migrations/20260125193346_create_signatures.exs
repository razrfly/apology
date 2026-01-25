defmodule Apology.Repo.Migrations.CreateSignatures do
  use Ecto.Migration

  def change do
    create table(:signatures) do
      add :display_name, :string
      add :comment, :text
      add :is_anonymous, :boolean, default: false
      add :verified, :boolean, default: false
      add :initiative_id, references(:initiatives, on_delete: :delete_all), null: false
      add :user_id, references(:users, on_delete: :nilify_all)

      timestamps(type: :utc_datetime)
    end

    create index(:signatures, [:initiative_id])
    create index(:signatures, [:user_id])
    # Prevent duplicate signatures per user per initiative
    create unique_index(:signatures, [:initiative_id, :user_id], where: "user_id IS NOT NULL")
  end
end
