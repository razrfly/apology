defmodule Apology.Repo.Migrations.ChangePhotoUrlToText do
  use Ecto.Migration

  def change do
    alter table(:targets) do
      modify :photo_url, :text, from: :string
    end
  end
end
