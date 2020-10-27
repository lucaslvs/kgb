defmodule KGB.ReviewTest do
  use ExUnit.Case

  alias KGB.Review

  import KGB.Factory

  describe "create/1" do
    test "should returns a Review when receive valid parameters" do
      parameters = %{
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
        mentioned_employees: build_list(3, :employee)
      }

      assert {:ok, %Review{}} = Review.create(parameters)
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a empty map" do
      assert {:error,
              {:validation,
               %{
                 content: ["is required"],
                 custom_service: ["is required"],
                 custumer_name: ["is required"],
                 friendliness: ["is required"],
                 mentioned_employees: ["is not a list", "is required"],
                 overall_experience: ["is required"],
                 pricing: ["is required"],
                 publication_date: ["is required"],
                 quality_of_work: ["is required"],
                 rating: ["is required", "is required"],
                 recommend_dealer: ["is required"]
               }}} = Review.create(%{})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a map with :mentioned_employees there isn't a list of Employee" do
      parameters = %{
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

      assert {:error,
              {:validation,
               %{
                 "mentioned_employees[0]" => [
                   "is not expected struct; expected: KGB.Employee; got: \"a\""
                 ]
               }}} = Review.create(parameters)
    end
  end

  describe "template_render/1" do
    test "should returns a string with Review data to print" do
      review = build(:review, recommend_dealer: "Yes")

      assert """
             CUSTUMER NAME: Custumer
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
             - Employee - 50
             - Employee - 50
             - Employee - 50

             """ = Review.template_render(review)
    end
  end

  describe "sort_by_overly_positive/1" do
    test "should sort reviews by rating criteria" do
      first_review = build(:review, rating: 50)
      second_review = build(:review, rating: 40)
      third_review = build(:review, rating: 30)
      reviews = Enum.shuffle([first_review, second_review, third_review])

      assert {:ok, sorted_reviews} = Review.sort_by_overly_positive(reviews)
      assert [first_review, second_review, third_review] = sorted_reviews
    end

    test "should sort reviews by employee's average rating criteria" do
      first_review = build(:review, mentioned_employees: build_list(3, :employee, rating: 50))

      second_review_employees = build_list(2, :employee, rating: 50) ++ [build(:employee, rating: 40)]
      second_review = build(:review, mentioned_employees: second_review_employees)

      third_review_employees = [build(:employee, rating: 50), build(:employee, rating: 40)]
      third_review = build(:review, mentioned_employees: third_review_employees)

      reviews = Enum.shuffle([first_review, second_review, third_review])

      assert {:ok, sorted_reviews} = Review.sort_by_overly_positive(reviews)
      assert [first_review, second_review, third_review] = sorted_reviews
    end

    test "should sort reviews by the number of mentioned employees" do
      first_review = build(:review, mentioned_employees: build_list(3, :employee))
      second_review = build(:review, mentioned_employees: build_list(2, :employee))
      third_review = build(:review, mentioned_employees: build_list(1, :employee))
      reviews = Enum.shuffle([first_review, second_review, third_review])

      assert {:ok, sorted_reviews} = Review.sort_by_overly_positive(reviews)
      assert [first_review, second_review, third_review] = sorted_reviews
    end

    test "should sort reviews by the number of rated topics" do
      first_review = build(:review)
      second_review = build(:review, pricing: 0)
      third_review = build(:review, pricing: 0, friendliness: 0)
      reviews = Enum.shuffle([first_review, second_review, third_review])

      assert {:ok, sorted_reviews} = Review.sort_by_overly_positive(reviews)
      assert [first_review, second_review, third_review] = sorted_reviews
    end
  end
end
