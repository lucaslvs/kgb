defmodule KGB do
  @moduledoc """
  The main module that contains the `print_top_three_reviews_overly_positive/0`
  function that spawn the `KGB.Spider` and prints the top three overly positive reviews.
  """

  @file_name "KGB.Spider.json"

  alias Crawly.Engine
  alias KGB.{Employee, Review, Spider}

  require Logger

  @doc """
  Print the top three overly positive reviews from DealerRater.
  """
  @spec print_top_three_reviews_overly_positive :: :ok
  def print_top_three_reviews_overly_positive do
    start_spider()
    |> read_parsed_items()
    |> delete_parsed_items()
    |> create_reviews()
    |> sort_reviews()
    |> print_top_three()
  end

  defp start_spider do
    Logger.info("Starting scraping the reviews", ansi_color: :green)
    Engine.start_spider(Spider)
  end

  defp read_parsed_items(:ok) do
    with {:file_exist, true} <- {:file_exist, File.exists?(@file_name)},
         {:ok, file} <- File.read(@file_name),
         parsed_items <- get_parsed_items(file),
         {:scrape_completed, true} <- {:scrape_completed, scraping_was_completed?(parsed_items)} do
      Logger.info("Successfully scraped reviews", ansi_color: :green)

      parsed_items
    else
      {:error, reason} ->
        Logger.error("Cannot read parsed items", reason: reason)

        stop()

      _ ->
        read_parsed_items(:ok)
    end
  end

  defp get_parsed_items(file) do
    file
    |> String.split("\n")
    |> List.delete_at(-1)
  end

  defp get_page_number do
    :kgb
    |> Application.get_env(Spider)
    |> Keyword.get(:page_number)
  end

  defp scraping_was_completed?(parsed_items) do
    length(parsed_items) >= get_page_number() * 10
  end

  defp delete_parsed_items(parsed_items) do
    Logger.info("Deleting #{@file_name} file", ansi_color: :green)

    case File.rm(@file_name) do
      :ok ->
        parsed_items

      _ ->
        Logger.warning("Failed to delete #{@file_name} file")

        parsed_items
    end
  end

  defp create_reviews(parsed_items) do
    Logger.info("Creating reviews", ansi_color: :green)

    parsed_items
    |> Stream.map(&Jason.decode!/1)
    |> Stream.map(&create_review/1)
    |> Enum.to_list()
  end

  defp create_review(parameters) do
    with {_parameters, updated_parameters} <- create_employees(parameters),
         {:ok, review} <- Review.create(updated_parameters) do
      review
    else
      {:error, reason} ->
        Logger.error("Failed to create review", reason: reason)

        stop()
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

        stop()
    end
  end

  defp sort_reviews(reviews) do
    Logger.info("Sorting reviews by overly positive", ansi_color: :green)

    case Review.sort_by_overly_positive(reviews: reviews) do
      {:ok, sorted_reviews} ->
        sorted_reviews

      {:error, reason} ->
        Logger.error("Failed to sort reviews", reason: reason)

        stop()
    end
  end

  defp print_top_three(sorted_reviews) do
    sorted_reviews
    |> Enum.slice(0..2)
    |> Enum.map(&Review.template_render/1)
    |> Enum.with_index()
    |> Enum.each(&print_review/1)
  end

  defp print_review({review, index}) do
    IO.puts("#{index + 1}º REVIEW")
    IO.puts(review)
  end

  defp stop do
    Process.sleep(1000)
    System.halt()
  end
end
