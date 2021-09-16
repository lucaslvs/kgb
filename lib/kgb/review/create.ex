defmodule KGB.Review.Create do
  @moduledoc false

  @rating_keys [
    :rating,
    :customer_service,
    :quality_of_work,
    :friendliness,
    :pricing,
    :overall_experience
  ]

  use Exop.Operation

  alias KGB.{Employee, Review}

  parameter(:customer_name, type: :string, from: "customer_name")
  parameter(:content, type: :string, from: "content")
  parameter(:publication_date, type: :string, from: "publication_date")

  parameter(:rating,
    type: :integer,
    from: "rating",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50},
    default: &__MODULE__.default_rating/1
  )

  parameter(:customer_service,
    type: :integer,
    from: "customer_service",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50},
    default: &__MODULE__.default_customer_service/1
  )

  parameter(:quality_of_work,
    type: :integer,
    from: "quality_of_work",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50},
    default: &__MODULE__.default_quality_of_work/1
  )

  parameter(:friendliness,
    type: :integer,
    from: "friendliness",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50},
    default: &__MODULE__.default_friendliness/1
  )

  parameter(:pricing,
    type: :integer,
    from: "pricing",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50},
    default: &__MODULE__.default_pricing/1
  )

  parameter(:overall_experience,
    type: :integer,
    from: "overall_experience",
    numericality: %{greater_than_or_equal_to: 0, less_than_or_equal_to: 50}
  )

  parameter(:recommend_dealer, type: :string, from: "recommend_dealer")
  parameter(:mentioned_employees, list_item: %{struct: Employee}, from: "mentioned_employees")

  @doc false
  @impl Exop.Operation
  def process(parameters) do
    {:ok, struct!(Review, parameters)}
  end

  Enum.each(@rating_keys, fn rating_key ->
    def unquote(:"default_#{to_string(rating_key)}")(parameters) do
      Map.get(parameters, unquote(rating_key), 0)
    end
  end)
end
