defmodule KGB.Review do
  @moduledoc """
  This module is responsible for model a review posted in `https://www.dealerrater.com/`.
  """

  alias __MODULE__.{Create, SortByOverlyPositive}

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
  """
  @spec create(keyword() | map()) :: {:error, any()} | {:ok, __MODULE__.t()}
  defdelegate create(parameters), to: Create, as: :run

  @doc """
  Sort a list of `KGB.Review.t()` by the following criteria:

  1. Highest rated `KGB.Review.t()` by the number of stars
  2. Number of rated topics
  3. The average of `KGB.Employee.t()` rating
  4. Number of `KGB.Employee.t()` mentioned in the review
  """
  @spec sort_by_overly_positive(keyword() | map()) ::
          {:error, any()} | {:ok, list(__MODULE__.t())}
  defdelegate sort_by_overly_positive(parameters), to: SortByOverlyPositive, as: :run
end
