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
      custom_service: 50,
      friendliness: 50,
      custumer_name: "Custumer",
      overall_experience: 50,
      pricing: 50,
      publication_date: "October 21, 2020",
      quality_of_work: 50,
      rating: 50,
      recommend_dealer: sequence(:recommend_dealer, ["Yes", "No"]),
      mentioned_employees: build_list(3, :employee)
    }
  end
end
