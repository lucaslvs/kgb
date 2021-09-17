defmodule KGB.Printer do
  @moduledoc false

  alias KGB.{Employee, Review}

  @doc """
  Print reviews in console until the `length` value.
  > `length` default value: `3`
  """
  @spec print_reviews(list(Review.t()), integer) :: :ok
  def print_reviews(reviews, length \\ 3) do
    until = length - 1

    reviews
    |> Enum.slice(0..until)
    |> Enum.map(&build_review_template_render/1)
    |> Enum.with_index()
    |> Enum.each(&print_review/1)
  end

  @doc """
  Build template render for a `KGB.Employee.t()` to be printed.
  """
  @spec build_employee_template_render(Employee.t()) :: binary()
  def build_employee_template_render(%Employee{name: name, rating: rating}) do
    "#{name}: #{rating}"
  end

  @doc """
  Build template render for a `KGB.Review.t()` to be printed.
  """
  @spec build_review_template_render(Review.t()) :: binary()
  def build_review_template_render(%Review{
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
    CUSTOMER NAME: #{customer_name}
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

  defp print_review({review, index}) do
    IO.puts("#{index + 1}º REVIEW")
    IO.puts(review)
  end

  defp render_employees(mentioned_employees) do
    Enum.map(mentioned_employees, &"- #{build_employee_template_render(&1)}\n")
  end
end
