defmodule KGB.Review.Create do
  @moduledoc false

  use Exop.Operation

  alias KGB.{Employee, Review}

  parameter(:from, type: :string, from: "from")
  parameter(:content, type: :string, from: "content")
  parameter(:published_at, type: :string, from: "published_at")

  parameter(:rating,
    type: :integer,
    from: "rating",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:rating,
    type: :integer,
    from: "rating",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:custom_service,
    type: :integer,
    from: "custom_service",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:quality_of_work,
    type: :integer,
    from: "quality_of_work",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:friendliness,
    type: :integer,
    from: "friendliness",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:pricing,
    type: :integer,
    from: "pricing",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:overall_experience,
    type: :integer,
    from: "overall_experience",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:recommendend_dealer, type: :string, from: "recommendend_dealer")
  parameter(:mentioned_employees, list_item: %{struct: Employee})

  @doc false
  @impl Exop.Operation
  def process(parameters) do
    {:ok, struct!(Review, parameters)}
  end
end