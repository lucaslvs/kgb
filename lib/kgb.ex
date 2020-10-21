defmodule KGB do
  @moduledoc false

  @doc """
  Sort a list of `KGB.Review.t()` by the following criteria:

  1. Highest rated `KGB.Review.t()` by the number of stars
  2. The average of `KGB.Employee.t()` rating
  3. Number of `KGB.Employee.t()` mentioned in the review
  4. Number of topics evaluated

  ## Examples

      #TODO
      iex> sort_reviews_by_overly_positive(reviews)
      []
  """
  @spec sort_reviews_by_overly_positive(list(KGB.Review.t())) :: list(KGB.Review.t())
  def sort_reviews_by_overly_positive(reviews) do
    Enum.sort_by(reviews, &overly_positive_sorter/1, :desc)
  end

  defp overly_positive_sorter(review) do
    employees = review["mentioned_employees"]
    average_employees_rating = calculate_average_employees_rating(employees)

    {review["rating"], average_employees_rating, length(employees)}
  end

  defp calculate_average_employees_rating(employees) do
    employees
    |> calculate_total_employees_rating()
    |> div(length(employees))
  end

  defp calculate_total_employees_rating(employees) do
    Enum.reduce(employees, 0, &(&1["rating"] + &2))
  end
end
