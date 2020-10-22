defmodule KGB.Employee.CalculateAverageRating do
  @moduledoc false

  use Exop.Operation

  alias KGB.Employee

  parameter(:employees, list_item: %{struct: Employee}, from: "employees")

  @doc false
  def process(parameters)

  def process(%{employees: employees}) do
    total_rating = Enum.reduce(employees, 0, &reducer/2)

    average_rating =
      if total_rating == 0 do
        total_rating
      else
        div(total_rating, length(employees))
      end

    {:ok, average_rating}
  end

  defp reducer(%Employee{rating: rating}, total), do: rating + total
end
