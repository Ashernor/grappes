require 'test_helper'
require 'database_cleaner'

class TravelTest < ActiveSupport::TestCase
  context "scopes" do

    setup do
      DatabaseCleaner.strategy = :truncation
      DatabaseCleaner.clean
    end

    should "return a travel with the scope between dates" do
      travel = create_dummy_travel
      start_date = Date.today.strftime("%m/%d/%Y")
      end_date = (Date.today+6.days).strftime("%m/%d/%Y")

      #request = Travel.between_dates(start_date, end_date)
      assert 1, request.count
      assert_equal travel, request.first
    end

    should "not return any travel if there isn't any between dates" do
      travel = create_dummy_travel
      start_date = Date.today.strftime("%m/%d/%Y")
      end_date = (Date.today+1.days).strftime("%m/%d/%Y")

      #request = Travel.between_dates(start_date, end_date)
      assert 0, request.count
    end

    should "return a travel if the price is in budget" do
      travel = create_dummy_travel

      request = Travel.in_budget(50, 100)
      assert 1, request.count
      assert_equal travel, request.first
    end

    should "return a travel if the price is equal to the minimum price" do
      travel = create_dummy_travel

      request = Travel.in_budget(89, 100)
      assert 1, request.count
      assert_equal travel, request.first
    end

    should "return a travel if the price is equal to the  maximum price" do
      travel = create_dummy_travel

      request = Travel.in_budget(50, 89)
      assert 1, request.count
      assert_equal travel, request.first
    end

    should "not return any travel if the price is lower" do
      travel = create_dummy_travel

      request = Travel.in_budget(50, 70)
      assert 0, request.count
    end

    should "not return any travel if the price is higher" do
      travel = create_dummy_travel

      request = Travel.in_budget(100, 170)
      assert 0, request.count
    end

    should "return travel if the number of people is lower than availaible" do
      travel = create_dummy_travel

      request = Travel.with_people(5)
      assert 1, request.count
      assert_equal travel, request.first
    end

    should "not return any travel if the number of people is greater than availaible" do
      travel = create_dummy_travel

      request = Travel.with_people(15)
      assert 0, request.count
    end

    should "only return travels where the city beginning by the string in from" do
      travel = create_dummy_travel

      request = Travel.from("Lyon")
      assert 1, request.count
      assert_equal travel, request.first
    end

    should "not return any travel if we enter the end_city" do
      travel = create_dummy_travel

      request = Travel.from("Paris")
      assert 0, request.count
    end
  end

  def create_dummy_travel
    Travel.create! start_city: "Lyon", end_city: "Paris", price: 89, places_available: 12, departure: Time.now+3.days, arrival: Time.now+4.days, direct_trip: true, company: "WWOS", lowcost: false, type: "Train", about: "Test travel", start_airport: "St Exupery", end_airport: "CDG"
  end
end
