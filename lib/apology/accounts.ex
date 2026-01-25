defmodule Apology.Accounts do
  @moduledoc """
  The Accounts context - user management.
  """
  import Ecto.Query

  alias Apology.Repo
  alias Apology.Accounts.User

  def get_user!(id), do: Repo.get!(User, id)

  def get_user_by_clerk_id(clerk_id) do
    Repo.get_by(User, clerk_id: clerk_id)
  end

  def get_user_by_email(email) do
    Repo.get_by(User, email: email)
  end

  def create_user(attrs \\ %{}) do
    %User{}
    |> User.changeset(attrs)
    |> Repo.insert()
  end

  def update_user(%User{} = user, attrs) do
    user
    |> User.changeset(attrs)
    |> Repo.update()
  end

  def find_or_create_user_by_clerk_id(clerk_id, attrs) do
    case get_user_by_clerk_id(clerk_id) do
      nil -> create_user(Map.put(attrs, :clerk_id, clerk_id))
      user -> {:ok, user}
    end
  end
end
