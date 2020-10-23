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
      |> Floki.find("div.review-entry")
      |> Stream.map(&fetch_review/1)
      |> Enum.to_list()

    %ParsedItem{items: items, requests: []}
  end

  defp build_start_url(number, dealer_path) do
    "#{base_url()}/dealer/#{dealer_path}/page#{number}"
  end

  defp fetch_review(review_document) do
    Map.new(
      custumer_name: find_review_custumer_name(review_document),
      content: find_review_content(review_document),
      publication_date: find_review_publication_date(review_document),
      rating: find_review_rating(review_document),
      custom_service: find_review_custom_service(review_document),
      quality_of_work: find_review_quality_of_work(review_document),
      friendliness: find_review_friendliness(review_document)
    )
  end

  defp find_review_custumer_name(review_document) do
    review_document
    |> Floki.find("div.review-wrapper > div:nth-child(1) > span")
    |> Floki.text()
    |> String.split()
    |> List.last()
  end

  defp find_review_content(review_document) do
    review_document
    |> Floki.find("div.review-wrapper > div:nth-child(2) > div > p")
    |> Floki.text()
  end

  defp find_review_publication_date(review_document) do
    review_document
    |> Floki.find("div.review-date > div.italic")
    |> Floki.text()
  end

  defp find_review_rating(review_document) do
    review_document
    |> Floki.find("div.dealership-rating > div.rating-static.margin-center")
    |> find_rating_value(2)
  end

  defp find_review_custom_service(review_document) do
    review_document
    |> Floki.find("div.review-ratings-all > div.table > div:nth-child(1) > div:nth-child(2)")
    |> find_rating_value(1)
  end

  defp find_review_quality_of_work(review_document) do
    review_document
    |> Floki.find("div.review-ratings-all > div.table > div:nth-child(2) > div:nth-child(2)")
    |> find_rating_value(1)
  end

  defp find_review_friendliness(review_document) do
    review_document
    |> Floki.find("div.review-ratings-all > div.table > div:nth-child(3) > div:nth-child(2)")
    |> find_rating_value(1)
  end

  defp find_rating_value(element, class_index) do
    element
    |> Floki.attribute("class")
    |> List.first()
    |> String.split()
    |> Enum.at(class_index)
    |> String.split("-")
    |> List.last()
    |> String.to_integer()
  end
end
