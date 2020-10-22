defmodule KGB.Review do
  @moduledoc """
  This module is responsible for model a review post in `https://www.dealerrater.com/`.
  """

  @enforce_keys [
    :from,
    :content,
    :published_at,
    :rating,
    :custom_service,
    :quality_of_work,
    :friendliness,
    :pricing,
    :overall_experience,
    :recommendend_dealer,
    :mentioned_employees
  ]

  defstruct @enforce_keys

  @type t() :: %KGB.Review{
          from: binary(),
          content: binary(),
          published_at: binary(),
          rating: integer(),
          custom_service: integer(),
          quality_of_work: integer(),
          friendliness: integer(),
          pricing: integer(),
          overall_experience: integer(),
          recommendend_dealer: binary(),
          mentioned_employees: list(KGB.Employee.t())
        }

  @doc """
  Create a `KGB.Review` by the given `parameters`.

  ## Examples

      iex> {:ok, employee} = KGB.Employee.create(%{name: "Lucas", rating: 50})
      {:ok, %KGB.Employee{name: "Lucas", rating: 50}}

      iex> valid_parameters = %{
      ... content: "some content",
      ... custom_service: 50,
      ... friendliness: 50,
      ... from: "client",
      ... overall_experience: 10,
      ... pricing: 10,
      ... published_at: "October 21, 2020",
      ... quality_of_work: 10,
      ... rating: 10,
      ... recommendend_dealer: "Yes",
      ... mentioned_employees: [employee]
      ... }
      %{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        from: "client",
        overall_experience: 10,
        pricing: 10,
        published_at: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommendend_dealer: "Yes",
        mentioned_employees: [%KGB.Employee{name: "Lucas", rating: 50}]
      }

      iex> KGB.Review.create(valid_parameters)
      {:ok, %KGB.Review{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        from: "client",
        mentioned_employees: [%KGB.Employee{name: "Lucas", rating: 50}],
        overall_experience: 10,
        pricing: 10,
        published_at: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommendend_dealer: "Yes"
      }}

      iex> invalid_parameters = %{
      ... content: "some content",
      ... custom_service: 50,
      ... friendliness: 50,
      ... from: "client",
      ... overall_experience: 10,
      ... pricing: 10,
      ... published_at: "October 21, 2020",
      ... quality_of_work: 10,
      ... rating: 10,
      ... recommendend_dealer: "Yes",
      ... mentioned_employees: []
      ... }
      %{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        from: "client",
        overall_experience: 10,
        pricing: 10,
        published_at: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommendend_dealer: "Yes",
        mentioned_employees: []
      }

      iex> KGB.Review.create(invalid_parameters)
      {:error, {:validation, %{mentioned_employees: ["length must be greater than or equal to 1; got length: 0"]}}}

      iex> invalid_parameters = %{
      ... content: "some content",
      ... custom_service: 50,
      ... friendliness: 50,
      ... from: "client",
      ... overall_experience: 10,
      ... pricing: 10,
      ... published_at: "October 21, 2020",
      ... quality_of_work: 10,
      ... rating: 10,
      ... recommendend_dealer: "Yes",
      ... mentioned_employees: ["a"]
      ... }
      %{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        from: "client",
        overall_experience: 10,
        pricing: 10,
        published_at: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommendend_dealer: "Yes",
        mentioned_employees: ["a"]
      }

      iex> KGB.Review.create(invalid_parameters)
      {:error, {:validation, %{ "mentioned_employees[0]" => ["is not expected struct; expected: KGB.Employee; got: \"a\""]}}}
  """
  @spec create(map()) :: {:ok, KGB.Review.t()} | {:error, any()}
  def create(parameters) when is_map(parameters) do
    __MODULE__.Create.run(parameters)
  end
end
