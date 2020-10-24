defmodule KGB do
  @moduledoc false

  @file_name "KGB.Spider.json"

  alias Crawly.Engine
  alias KGB.{Employee, Review, Spider}

  require Logger

  @doc """

  """
  @spec start :: :ok
  def start do
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
    if File.exists?(@file_name) do
      {:ok, file} = File.read(@file_name)
      parsed_items = get_parsed_items(file)

      if length(parsed_items) >= get_page_number() * 10 do
        Logger.info("Successfully scraped reviews", ansi_color: :green)
        parsed_items
      else
        read_parsed_items(:ok)
      end
    else
      read_parsed_items(:ok)
    end
  end

  defp read_parsed_items(_) do
    Logger.error("Cannot read parsed items")
    System.halt()
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

  defp delete_parsed_items(parsed_items) do
    Logger.info("Deleting #{@file_name} file", ansi_color: :green)

    :ok = File.rm(@file_name)
    parsed_items
  end

  defp create_reviews(parsed_items) do
    Logger.info("Creating reviews", ansi_color: :green)

    parsed_items
    |> Stream.map(&Jason.decode!/1)
    |> Stream.map(&create_review/1)
    |> Enum.to_list()
  end

  defp create_review(parameters) do
    mentioned_employees =
      parameters
      |> Map.get("mentioned_employees")
      |> Enum.map(&create_employee/1)

    {:ok, review} =
      parameters
      |> Map.put("mentioned_employees", mentioned_employees)
      |> Review.create()

    review
  end

  defp create_employee(parameters) do
    {:ok, employee} = Employee.create(parameters)

    employee
  end

  defp sort_reviews(reviews) do
    Logger.info("Sorting reviews by overly positive", ansi_color: :green)
    {:ok, sorted_reviews} = Review.sort_by_overly_positive(reviews)

    sorted_reviews
  end

  defp print_top_three(_sorted_reviews) do
    :ok
  end
end
