defmodule Apology.Wikipedia do
  @moduledoc """
  Client for Wikipedia REST API to fetch public figure data.
  """

  @base_url "https://en.wikipedia.org/api/rest_v1/page/summary"

  @doc """
  Fetches person data from Wikipedia.

  ## Example

      iex> Apology.Wikipedia.get_person("Tim_Cook")
      {:ok, %{
        title: "Tim Cook",
        description: "American business executive",
        extract: "Timothy Donald Cook is...",
        thumbnail_url: "https://upload.wikimedia.org/..."
      }}
  """
  def get_person(wikipedia_title) when is_binary(wikipedia_title) do
    url = "#{@base_url}/#{wikipedia_title}"

    case Req.get(url) do
      {:ok, %{status: 200, body: body}} ->
        {:ok,
         %{
           title: body["title"],
           description: body["description"],
           extract: body["extract"],
           thumbnail_url: get_in(body, ["thumbnail", "source"])
         }}

      {:ok, %{status: 404}} ->
        {:error, :not_found}

      {:error, reason} ->
        {:error, reason}
    end
  end

  def get_person(nil), do: {:error, :no_title}

  @doc """
  Fetches person data, returning nil on error (useful for seeds).
  """
  def get_thumbnail_url(wikipedia_title) do
    case get_person(wikipedia_title) do
      {:ok, %{thumbnail_url: url}} when not is_nil(url) -> url
      _ -> nil
    end
  end
end
