defmodule KGB.EmployeeTest do
  use ExUnit.Case

  alias KGB.Employee

  import KGB.Factory

  describe "create/1" do
    test "should returns a Employee when receive valid parameters" do
      assert {:ok, %Employee{name: "Lucas", rating: 50}} =
               Employee.create(%{name: "Lucas", rating: 50})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a empty map" do
      assert {:error, {:validation, %{name: ["is required"], rating: ["is required"]}}} =
               Employee.create(%{})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a map without :name" do
      assert {:error, {:validation, %{name: ["is required"]}}} = Employee.create(%{rating: 50})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a map without :rating" do
      assert {:error, {:validation, %{name: ["is required"]}}} = Employee.create(%{rating: 50})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a map with :name empty" do
      {:error,
       {:validation, %{name: ["length must be greater than or equal to 1; got length: 0"]}}} =
        Employee.create(%{name: "", rating: 10})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a map with :rating less than 0" do
      {:error, {:validation, %{rating: ["must be greater than or equal to 0; got: -1"]}}} =
        Employee.create(%{name: "Lucas", rating: -1})
    end

    @tag capture_log: true
    test "should returns a error tuple when receive a map with :rating greater than 50" do
      {:error, {:validation, %{rating: ["must be less than or equal to 50; got: 51"]}}} =
        Employee.create(%{name: "Lucas", rating: 51})
    end
  end

  describe "calculate_average_rating/1" do
    test "returns the average rating from the Employee list" do
      employees = build_list(3, :employee)
      assert {:ok, 50} = Employee.calculate_average_rating(employees)
    end

    test "returns 0 when receive a empty list" do
      assert {:ok, 0} = Employee.calculate_average_rating([])
    end
  end
end
