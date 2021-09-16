defmodule KGB.Review do
  @moduledoc """
  This module is responsible for model a review posted in `https://www.dealerrater.com/`.
  """

  alias __MODULE__.{Create, SortByOverlyPositive}
  alias KGB.Employee

  @enforce_keys [
    :customer_name,
    :content,
    :publication_date,
    :rating,
    :customer_service,
    :quality_of_work,
    :friendliness,
    :pricing,
    :overall_experience,
    :recommend_dealer,
    :mentioned_employees
  ]

  defstruct @enforce_keys

  @type t() :: %__MODULE__{
          customer_name: binary(),
          content: binary(),
          publication_date: binary(),
          rating: non_neg_integer(),
          customer_service: non_neg_integer(),
          quality_of_work: non_neg_integer(),
          friendliness: non_neg_integer(),
          pricing: non_neg_integer(),
          overall_experience: non_neg_integer(),
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
      ...> customer_service: 50,
      ...> friendliness: 50,
      ...> customer_name: "client",
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
        customer_service: 50,
        friendliness: 50,
        customer_name: "client",
        overall_experience: 10,
        pricing: 10,
        publication_date: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommend_dealer: "Yes",
        mentioned_employees: [%KGB.Employee{name: "Lucas", rating: 50}]
      }

      iex> KGB.Review.run(valid_parameters)
      {:ok, %KGB.Review{
        content: "some content",
        customer_service: 50,
        friendliness: 50,
        customer_name: "client",
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
      ...> customer_service: 50,
      ...> friendliness: 50,
      ...> customer_name: "client",
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
        customer_service: 50,
        friendliness: 50,
        customer_name: "client",
        overall_experience: 10,
        pricing: 10,
        publication_date: "October 21, 2020",
        quality_of_work: 10,
        rating: 10,
        recommend_dealer: "Yes",
        mentioned_employees: ["a"]
      }

      iex> KGB.Review.run(invalid_parameters)
      {:error, {:validation, %{ "mentioned_employees[0]" => ["is not expected struct; expected: KGB.Employee; got: \"a\""]}}}
  """
  @spec create(keyword() | map()) :: {:error, any()} | {:ok, __MODULE__.t()}
  defdelegate create(parameters), to: Create, as: :run

  @doc """
  Sort a list of `KGB.Review.t()` by the following criteria:

  1. Highest rated `KGB.Review.t()` by the number of stars
  2. The average of `KGB.Employee.t()` rating
  3. Number of `KGB.Employee.t()` mentioned in the review
  4. Number of rated topics
  """
  @spec sort_by_overly_positive(keyword() | map()) ::
          {:error, any()} | {:ok, list(__MODULE__.t())}
  defdelegate sort_by_overly_positive(parameters), to: SortByOverlyPositive, as: :run

  @doc """
  Build template render for a `KGB.Review.t()` to be printed.
  """
  @spec build_template_render(KGB.Review.t()) :: binary()
  def build_template_render(%__MODULE__{
        customer_name: customer_name,
        content: content,
        publication_date: publication_date,
        rating: rating,
        customer_service: customer_service,
        quality_of_work: quality_of_work,
        friendliness: friendliness,
        pricing: pricing,
        overall_experience: overall_experience,
        recommend_dealer: recommend_dealer,
        mentioned_employees: mentioned_employees
      }) do
    """
    customer NAME: #{customer_name}
    PUBLICATION DATE: #{publication_date}
    RATING: #{rating}
    CONTENT: #{content}
    CUSTOM SERVICE: #{customer_service}
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
    Enum.map(mentioned_employees, &"- #{Employee.build_template_render(&1)}\n")
  end
end
