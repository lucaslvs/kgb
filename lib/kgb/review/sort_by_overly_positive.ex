defmodule KGB.Review.SortByOverlyPositive do
  @moduledoc false

  @topics [:custom_service, :quality_of_work, :friendliness, :pricing, :overall_experience]

  use Exop.Operation

  alias KGB.{Employee, Review}

  parameter(:reviews, list_item: %{struct: Review}, from: "reviews")

  @doc false
  @impl Exop.Operation
  def process(parameters)

  def process(%{reviews: reviews}) do
    {:ok, Enum.sort_by(reviews, &sorter/1, :desc)}
  end

  defp sorter(%Review{} = review) do
    {
      by_rating(review),
      by_employees_average_rating(review),
      by_number_of_employees(review),
      by_number_of_rated_topics(review)
    }
  end

  defp by_rating(review)
  defp by_rating(%Review{rating: rating}), do: rating

  defp by_employees_average_rating(review)

  defp by_employees_average_rating(%Review{mentioned_employees: employees}) do
    {:ok, employees_average_rating} = Employee.calculate_average_rating(employees)
    employees_average_rating
  end

  defp by_number_of_employees(review)
  defp by_number_of_employees(%Review{mentioned_employees: employees}), do: length(employees)

  defp by_number_of_rated_topics(review) do
    review
    |> Map.take(@topics)
    |> Map.values()
    |> Enum.sum()
    |> div(length(@topics))
  end
end
