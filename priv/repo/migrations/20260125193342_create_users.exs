defmodule Apology.Repo.Migrations.CreateUsers do
  use Ecto.Migration

  def change do
    create table(:users) do
      add :clerk_id, :string, null: false
      add :email, :string, null: false
      add :display_name, :string
      add :avatar_url, :string

      timestamps(type: :utc_datetime)
    end

    create unique_index(:users, [:clerk_id])
    create unique_index(:users, [:email])
  end
end
