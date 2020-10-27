defmodule KGB.Employee do
  @moduledoc """
  This module is responsible for model an employee mentioned in the `KGB.Review.t()`.
  """

  @enforce_keys [:name, :rating]

  defstruct @enforce_keys

  @type t() :: %KGB.Employee{name: binary(), rating: integer()}

  @doc """
  Create a `KGB.Employee` by the given `parameters`.

  ## Examples

      iex> KGB.Employee.create(%{name: "Lucas", rating: 50})
      {:ok %KGB.Employee{name: "Lucas", rating: 50}}

      iex> KGB.Employee.create(%{rating: 50})
      {:error, {:validation, %{name: ["is required"]}}}

      iex> KGB.Employee.create(%{name: "Lucas"})
      {:error, {:validation, %{name: ["is required"]}}}

      iex> KGB.Employee.create(%{name: "Lucas", rating: 51})
      {:error, {:validation, %{rating: ["must be less than or equal to 50; got: 51"]}}}

      iex> KGB.Employee.create(%{name: "Lucas", rating: -1})
      {:error, {:validation, %{rating: ["must be greater than or equal to 0; got: -1"]}}}
  """
  @spec create(map()) :: {:ok, KGB.Employee.t()} | {:error, any()}
  def create(parameters) when is_map(parameters) do
    __MODULE__.Create.run(parameters)
  end

  @doc """
  Calculate the average rating from a list of `KGB.Employee`.

  ## Examples

      iex> employees = [
      ...> %Employee{name: "1", rating: 10},
      ...> %Employee{name: "2", rating: 20},
      ...> %Employee{name: "3", rating: 30}
      ...> ]
      [%Employee{name: "1", rating: 10}, %Employee{name: "2", rating: 20}, %Employee{name: "3", rating: 30}]

      iex> Employee.calculate_average_rating(employees)
      {:ok, 20}
  """
  @spec calculate_average_rating(list(KGB.Employee.t() | [])) ::
          {:ok, integer()} | {:error, any()}
  def calculate_average_rating(employees) when is_list(employees) do
    __MODULE__.CalculateAverageRating.run(employees: employees)
  end

  @doc """
  Build template render for a `KGB.Employee.t()` to be printed.
  """
  @spec template_render(KGB.Employee.t()) :: binary()
  def template_render(%__MODULE__{name: name, rating: rating}) do
    "#{name} - #{rating}"
  end
end
