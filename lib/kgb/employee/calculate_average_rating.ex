defmodule KGB.Employee.CalculateAverageRating do
  @moduledoc false

  use Exop.Operation

  alias KGB.Employee

  parameter(:employees, list_item: %{struct: Employee}, from: "employees")

  @doc false
  def process(parameters)

  def process(%{employees: employees}) do
    rating = Enum.reduce(employees, 0, &reducer/2)
    average_rating = if rating == 0, do: rating, else: div(rating, length(employees))

    {:ok, average_rating}
  end

  defp reducer(%Employee{rating: rating}, total), do: rating + total
end
