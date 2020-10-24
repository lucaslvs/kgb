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
end