defmodule KGB.Spider do
  @moduledoc """
  """

  @config Application.get_env(:kgb, __MODULE__)

  use Crawly.Spider

  alias Crawly.ParsedItem
  alias HTTPoison.Response

  @impl Crawly.Spider
  def base_url, do: Keyword.get(@config, :base_url)

  @impl Crawly.Spider
  def init do
    page_number = Keyword.get(@config, :page_number)
    dealer_path = Keyword.get(@config, :dealer_path)
    start_urls = Enum.map(1..page_number, &build_start_url(&1, dealer_path))

    Keyword.new(start_urls: start_urls)
  end

  @impl Crawly.Spider
  def parse_item(%Response{body: body}) do
    {:ok, document} = Floki.parse_document(body)

    items =
      document
      |> find_reviews()
      |> build_reviews()

    %ParsedItem{items: items, requests: []}
  end

  defp build_start_url(number, dealer_path) do
    "#{base_url()}/dealer/#{dealer_path}/page#{number}"
  end

  defp find_reviews(document) do
    Floki.find(document, "div.review-entry")
  end

  defp build_reviews(reviews) do
    Enum.map(reviews, fn review ->
      rating = find_review_rating(review)
      Map.new(rating: rating)
    end)
  end

  defp find_review_rating(review) do
    review
    |> Floki.find("div.dealership-rating > div.rating-static.margin-center")
    |> Floki.attribute("class")
    |> List.first()
    |> String.split()
    |> Enum.at(2)
    |> String.split("-")
    |> List.last()
    |> String.to_integer()
  end
end
