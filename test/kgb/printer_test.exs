defmodule KGB.PrinterTest do
  use ExUnit.Case

  alias KGB.Printer

  import ExUnit.CaptureIO
  import KGB.Factory

  describe "build_employee_template_render/1" do
    test "should returns a string with employee data to print" do
      employee = build(:employee)
      employee_template = Printer.build_employee_template_render(employee)

      assert "Employee: 50" = employee_template
    end
  end

  describe "build_review_template_render/1" do
    test "should returns a string with Review data to print" do
      review = build(:review, recommend_dealer: "Yes")

      assert """
             CUSTOMER NAME: customer
             PUBLICATION DATE: October 21, 2020
             RATING: 50
             CONTENT: some content
             CUSTOM SERVICE: 50
             QUALITY OF WORK: 50
             FRIENDLINESS: 50
             PRICING: 50
             OVERALL EXPERIENCE: 50
             RECOMMEND_DEALER: Yes
             MENTIONED EMPLOYEES:
             - Employee: 50
             - Employee: 50
             - Employee: 50

             """ = Printer.build_review_template_render(review)
    end
  end

  describe "print_reviews/1" do
    setup do
      reviews = build_list(5, :review, recommend_dealer: "Yes")

      {:ok, reviews: reviews}
    end

    test "should print the first three reviews", %{reviews: reviews} do
      assert capture_io(fn -> Printer.print_reviews(reviews) end) =~ """
             1º REVIEW
             CUSTOMER NAME: customer
             PUBLICATION DATE: October 21, 2020
             RATING: 50
             CONTENT: some content
             CUSTOM SERVICE: 50
             QUALITY OF WORK: 50
             FRIENDLINESS: 50
             PRICING: 50
             OVERALL EXPERIENCE: 50
             RECOMMEND_DEALER: Yes
             MENTIONED EMPLOYEES:
             - Employee: 50
             - Employee: 50
             - Employee: 50


             2º REVIEW
             CUSTOMER NAME: customer
             PUBLICATION DATE: October 21, 2020
             RATING: 50
             CONTENT: some content
             CUSTOM SERVICE: 50
             QUALITY OF WORK: 50
             FRIENDLINESS: 50
             PRICING: 50
             OVERALL EXPERIENCE: 50
             RECOMMEND_DEALER: Yes
             MENTIONED EMPLOYEES:
             - Employee: 50
             - Employee: 50
             - Employee: 50


             3º REVIEW
             CUSTOMER NAME: customer
             PUBLICATION DATE: October 21, 2020
             RATING: 50
             CONTENT: some content
             CUSTOM SERVICE: 50
             QUALITY OF WORK: 50
             FRIENDLINESS: 50
             PRICING: 50
             OVERALL EXPERIENCE: 50
             RECOMMEND_DEALER: Yes
             MENTIONED EMPLOYEES:
             - Employee: 50
             - Employee: 50
             - Employee: 50
             """
    end
  end

  describe "print_reviews/2" do
    setup do
      reviews = build_list(5, :review, recommend_dealer: "Yes")

      {:ok, reviews: reviews}
    end

    test "should print the first three reviews", %{reviews: reviews} do
      assert capture_io(fn -> Printer.print_reviews(reviews, 1) end) =~ """
             1º REVIEW
             CUSTOMER NAME: customer
             PUBLICATION DATE: October 21, 2020
             RATING: 50
             CONTENT: some content
             CUSTOM SERVICE: 50
             QUALITY OF WORK: 50
             FRIENDLINESS: 50
             PRICING: 50
             OVERALL EXPERIENCE: 50
             RECOMMEND_DEALER: Yes
             MENTIONED EMPLOYEES:
             - Employee: 50
             - Employee: 50
             - Employee: 50
             """
    end
  end
end
