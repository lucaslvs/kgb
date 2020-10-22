defmodule KGB.Review.SortByOverlyPositive do
  @moduledoc false

  use Exop.Operation

  alias KGB.{Employee, Review}

  parameter(:reviews, list_item: %{struct: Review}, from: "reviews")

  @doc false
  @impl Exop.Operation
  def process(parameters)

  def process(%{reviews: reviews}) do
    {:ok, Enum.sort_by(reviews, &sorter/1, :desc)}
  end

  defp sorter(%Review{rating: rating, mentioned_employees: employees}) do
    {:ok, employees_average_rating} = Employee.calculate_average_rating(employees)
    {rating, employees_average_rating, length(employees)}
  end
end
