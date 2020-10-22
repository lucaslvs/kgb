defmodule KGB.Employee do
  @moduledoc """
  This module is responsible for model an employee mentioned in the `KGB.Review`.
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
end
