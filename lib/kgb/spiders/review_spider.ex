defmodule KGB.ReviewSpider do
  @moduledoc """
  That module is a implementation of `Crawly.Spider`
  and is resposible to scrape a list of `KGB.Review.t()`.
  """

  use Crawly.Spider

  alias Crawly.ParsedItem
  alias HTTPoison.Response

  @impl Crawly.Spider
  def base_url, do: Keyword.get(config(), :base_url)

  @impl Crawly.Spider
  def init do
    page_number = Keyword.get(config(), :page_number)
    dealer_path = Keyword.get(config(), :dealer_path)
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

  defp config, do: Application.get_env(:kgb, __MODULE__)

  defp build_start_url(number, dealer_path) do
    "#{base_url()}/dealer/#{dealer_path}/page#{number}"
  end

  defp fetch_review(review_document) do
    Map.new()
    |> Map.put(:customer_name, find_review_customer_name(review_document))
    |> Map.put(:content, find_review_content(review_document))
    |> Map.put(:publication_date, find_review_publication_date(review_document))
    |> Map.put(:rating, find_review_rating(review_document))
    |> Map.put(:mentioned_employees, find_review_mentioned_employees(review_document))
    |> fetch_review_ratings(review_document)
  end

  defp find_review_customer_name(review_document) do
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

  defp find_review_mentioned_employees(review_document) do
    review_document
    |> Floki.find("div.review-employee > div.table > div:nth-child(2)")
    |> Enum.map(&fetch_employee/1)
  end

  defp fetch_employee(employee_document) do
    name = find_employee_name(employee_document)
    rating = find_employee_rating(employee_document)

    Map.new(name: name, rating: rating)
  end

  defp find_employee_name(employee_document) do
    employee_document
    |> Floki.find("a")
    |> Floki.text()
    |> String.trim()
  end

  defp find_employee_rating(employee_document) do
    employee_document
    |> Floki.find("div > div > div > div.rating-static")
    |> find_rating_value(1)
  end

  defp fetch_review_ratings(review, review_document) do
    review_document
    |> Floki.find("div.review-ratings-all > div.table > div.tr")
    |> Enum.reduce(%{}, &find_review_ratings/2)
    |> Map.merge(review)
  end

  defp find_review_ratings(review_rating_document, review_ratings) do
    rating_name = fetch_review_rating_name(review_rating_document)
    rating_value = fetch_review_rating_value(review_rating_document)

    Map.put(review_ratings, rating_name, rating_value)
  end

  defp fetch_review_rating_name(review_ratings_document) do
    review_ratings_document
    |> Floki.find("div:nth-child(1)")
    |> Floki.text()
    |> String.trim()
    |> String.downcase()
    |> String.replace(" ", "_")
    |> String.to_atom()
  end

  defp fetch_review_rating_value(review_ratings_document) do
    rating_value = Floki.find(review_ratings_document, "div:nth-child(2)")

    case Floki.text(rating_value) do
      "" ->
        find_rating_value(rating_value, 1)

      _ ->
        rating_value
        |> Floki.text()
        |> String.trim()
    end
  end

  defp find_rating_value(element, index) do
    element
    |> Floki.attribute("class")
    |> List.first()
    |> String.split()
    |> Enum.at(index)
    |> String.split("-")
    |> List.last()
    |> String.to_integer()
  end
end
