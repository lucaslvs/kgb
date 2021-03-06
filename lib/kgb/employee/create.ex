defmodule KGB.Employee.Create do
  @moduledoc false

  use Exop.Operation

  alias KGB.Employee

  parameter(:name, type: :string, from: "name", length: %{min: 1})

  parameter(:rating,
    type: :integer,
    from: "rating",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  @doc false
  @impl Exop.Operation
  def process(parameters) do
    {:ok, struct!(Employee, parameters)}
  end
end
