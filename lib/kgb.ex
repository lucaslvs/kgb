defmodule KGB do
  @moduledoc """
  The main module that contains the `print_top_reviews_overly_positive/0`
  function that spawn the `KGB.ReviewSpider` and prints the top overly positive reviews.
  """

  @reviews_file "KGB.ReviewSpider.json"
  @review_by_page 10

  alias Crawly.Engine
  alias KGB.{Employee, Printer, Review, ReviewSpider}

  require Logger

  @doc """
  Print the top three overly positive reviews from DealerRater.
  """
  @spec print_top_reviews_overly_positive :: :ok
  def print_top_reviews_overly_positive do
    with :ok <- start_spider(ReviewSpider),
         page_number when is_integer(page_number) <- get_reviews_page_number(),
         {:ok, parsed_items} <- read_parsed_items(@reviews_file, page_number, @review_by_page),
         :ok <- delete_parsed_items(@reviews_file),
         {:ok, reviews} <- create_reviews(parsed_items),
         {:ok, sorted_reviews} <- sort_reviews(reviews) do
      Printer.print_reviews(sorted_reviews)
    else
      _ ->
        Logger.error("Failed to print top reviews overly positive")
    end
  end

  defp start_spider(spider_name) do
    Engine.start_spider(spider_name)
  end

  defp read_parsed_items(file_name, page_number, items_by_page) do
    with {:file_exist, true} <- {:file_exist, File.exists?(file_name)},
         {:ok, file} <- File.read(file_name),
         parsed_items <- get_parsed_items(file),
         {:scraped, true} <- {:scraped, scrapped?(parsed_items, page_number, items_by_page)} do
      {:ok, parsed_items}
    else
      {:error, reason} ->
        Logger.error("Cannot read parsed items", reason: reason)

      _ ->
        read_parsed_items(file_name, page_number, items_by_page)
    end
  end

  defp get_parsed_items(file) do
    file
    |> String.split("\n")
    |> List.delete_at(-1)
  end

  defp get_reviews_page_number do
    :kgb
    |> Application.get_env(ReviewSpider)
    |> Keyword.get(:page_number)
  end

  defp scrapped?(parsed_items, page_number, items_by_page) do
    length(parsed_items) >= page_number * items_by_page
  end

  defp delete_parsed_items(file_name), do: File.rm(file_name)

  defp create_reviews(parsed_items) do
    reviews =
      parsed_items
      |> Stream.map(&Jason.decode!/1)
      |> Stream.map(&create_review/1)
      |> Enum.to_list()

    {:ok, reviews}
  end

  defp create_review(parameters) do
    with {_parameters, updated_parameters} <- create_employees(parameters),
         {:ok, review} <- Review.create(updated_parameters) do
      review
    else
      {:error, reason} ->
        Logger.error("Failed to create review", reason: reason)
    end
  end

  defp create_employees(parameters) do
    Map.get_and_update(parameters, "mentioned_employees", fn employees_parameters ->
      {employees_parameters, Enum.map(employees_parameters, &create_employee/1)}
    end)
  end

  defp create_employee(parameters) do
    case Employee.create(parameters) do
      {:ok, employee} ->
        employee

      {:error, reason} ->
        Logger.error("Failed to create employee", reason: reason)
    end
  end

  defp sort_reviews(reviews) do
    case Review.sort_by_overly_positive(reviews: reviews) do
      {:error, reason} ->
        Logger.error("Failed to sort reviews", reason: reason)

      sorted_reviews ->
        sorted_reviews
    end
  end
end
