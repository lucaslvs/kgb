defmodule KGB.Review do
  @moduledoc """
  This module is responsible for model a review posted in `https://www.dealerrater.com/`.
  """

  alias KGB.Employee

  @enforce_keys [
    :custumer_name,
    :content,
    :publication_date,
    :rating,
    :custom_service,
    :quality_of_work,
    :friendliness,
    :pricing,
    :overall_experience,
    :recommend_dealer,
    :mentioned_employees
  ]

  defstruct @enforce_keys

  @type t() :: %KGB.Review{
          custumer_name: binary(),
          content: binary(),
          publication_date: binary(),
          rating: integer(),
          custom_service: integer(),
          quality_of_work: integer(),
          friendliness: integer(),
          pricing: integer(),
          overall_experience: integer(),
          recommend_dealer: binary(),
          mentioned_employees: list(KGB.Employee.t())
        }

  @doc """
  Create a `KGB.Review` by the given `parameters`.

  ## Examples

      iex> {:ok, employee} = KGB.Employee.create(%{name: "Lucas", rating: 50})
      {:ok, %KGB.Employee{name: "Lucas", rating: 50}}

      iex> valid_parameters = %{
      ...> content: "some content",
      ...> custom_service: 50,
      ...> friendliness: 50,
      ...> custumer_name: "client",
      ...> overall_experience: 10,
      ...> pricing: 10,
      ...> publication_date: "October 21, 2020",
      ...> quality_of_work: 10,
      ...> rating: 10,
      ...> recommend_dealer: "Yes",
      ...> mentioned_employees: [employee]
      ...> }
      %{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        custumer_name: "client",
        overall_experience: 10,
        pricing: 10,
        publication_date: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommend_dealer: "Yes",
        mentioned_employees: [%KGB.Employee{name: "Lucas", rating: 50}]
      }

      iex> KGB.Review.create(valid_parameters)
      {:ok, %KGB.Review{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        custumer_name: "client",
        mentioned_employees: [%KGB.Employee{name: "Lucas", rating: 50}],
        overall_experience: 10,
        pricing: 10,
        publication_date: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommend_dealer: "Yes"
      }}

      iex> invalid_parameters = %{
      ...> content: "some content",
      ...> custom_service: 50,
      ...> friendliness: 50,
      ...> custumer_name: "client",
      ...> overall_experience: 10,
      ...> pricing: 10,
      ...> publication_date: "October 21, 2020",
      ...> quality_of_work: 10,
      ...> rating: 10,
      ...> recommend_dealer: "Yes",
      ...> mentioned_employees: ["a"]
      ...> }
      %{
        content: "some content",
        custom_service: 50,
        friendliness: 50,
        custumer_name: "client",
        overall_experience: 10,
        pricing: 10,
        publication_date: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommend_dealer: "Yes",
        mentioned_employees: ["a"]
      }

      iex> KGB.Review.create(invalid_parameters)
      {:error, {:validation, %{ "mentioned_employees[0]" => ["is not expected struct; expected: KGB.Employee; got: \"a\""]}}}
  """
  @spec create(map()) :: {:ok, KGB.Review.t()} | {:error, any()}
  def create(parameters) when is_map(parameters) do
    __MODULE__.Create.run(parameters)
  end

  @doc """
  Sort a list of `KGB.Review.t()` by the following criteria:

  1. Highest rated `KGB.Review.t()` by the number of stars
  2. The average of `KGB.Employee.t()` rating
  3. Number of `KGB.Employee.t()` mentioned in the review
  4. Number of rated topics

  ## Examples

      #TODO
      iex> {:ok, sorted_reviews} = sort_reviews_by_overly_positive(reviews)
      []
  """
  @spec sort_by_overly_positive(list(KGB.Review.t())) ::
          {:ok, list(KGB.Review.t())} | {:error, any()}
  def sort_by_overly_positive(reviews) do
    __MODULE__.SortByOverlyPositive.run(reviews: reviews)
  end

  @spec template_render(KGB.Review.t()) :: binary()
  def template_render(%__MODULE__{
        custumer_name: custumer_name,
        content: content,
        publication_date: publication_date,
        rating: rating,
        custom_service: custom_service,
        quality_of_work: quality_of_work,
        friendliness: friendliness,
        pricing: pricing,
        overall_experience: overall_experience,
        recommend_dealer: recommend_dealer,
        mentioned_employees: mentioned_employees
      }) do
    """
    CUSTUMER NAME: #{custumer_name}
    PUBLICATION DATE: #{publication_date}
    RATING: #{rating}
    CONTENT: #{content}
    CUSTOM SERVICE: #{custom_service}
    QUALITY OF WORK: #{quality_of_work}
    FRIENDLINESS: #{friendliness}
    PRICING: #{pricing}
    OVERALL EXPERIENCE: #{overall_experience}
    RECOMMEND_DEALER: #{recommend_dealer}
    MENTIONED EMPLOYEES:
    #{render_employees(mentioned_employees)}
    """
  end

  defp render_employees(mentioned_employees) do
    Enum.map(mentioned_employees, &"- #{Employee.template_render(&1)}\n")
  end
end
