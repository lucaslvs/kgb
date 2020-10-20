defmodule KGB.Review do
  @enforce_keys [
    :from,
    :content,
    :rating,
    :published_at,
    :custom_service_rating,
    :quality_of_work_rating,
    :friendliness_rating,
    :pricing_rating,
    :overall_experience_rating,
    :recommendend_dealer_rating,
    :employees_worked_with
  ]

  defstruct @enforce_keys
end
