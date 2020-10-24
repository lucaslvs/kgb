defmodule KGB.Factory do
  @moduledoc false

  use ExMachina

  alias KGB.{Employee, Review}

  @doc false
  def employee_factory do
    %Employee{name: "Employee", rating: 50}
  end

  @doc false
  def review_factory do
    %Review{
      content: "some content",
      custom_service: sequence(:custom_service, 1..50),
      friendliness: sequence(:friendliness, 1..50),
      custumer_name: "Custumer",
      overall_experience: sequence(:overall_experience, 1..50),
      pricing: sequence(:pricing, 1..50),
      publication_date: "October 21, 2020",
      quality_of_work: sequence(:quality_of_work, 1..50),
      rating: sequence(:rating, 1..50),
      recommend_dealer: sequence(:recommend_dealer, ["Yes", "No"]),
      mentioned_employees: build_list(3, :employee)
    }
  end
end
