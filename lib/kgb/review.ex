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
end
