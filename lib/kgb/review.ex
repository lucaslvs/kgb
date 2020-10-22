defmodule KGB.Review do
  @enforce_keys [
    :from,
    :content,
    :rating,
    :published_at,
    :custom_service,
    :quality_of_work,
    :friendliness,
    :pricing,
    :overall_experience,
    :recommendend_dealer,
    :mentioned_employees
  ]

  defstruct @enforce_keys
end
