require 'test_helper'

class TravelsControllerTest < ActionController::TestCase
  setup do
    @travel = travels(:one)
  end

  test "should get index" do
    get :index
    assert_response :success
    assert_not_nil assigns(:travels)
  end

  test "should get new" do
    get :new
    assert_response :success
  end

  test "should create travel" do
    assert_difference('Travel.count') do
      post :create, travel: { about: @travel.about, arrival_time: @travel.arrival_time, company: @travel.company, departure_time: @travel.departure_time, direct_trip: @travel.direct_trip, end_airport: @travel.end_airport, end_city: @travel.end_city, lowcost: @travel.lowcost, places_available: @travel.places_available, price: @travel.price, start_airport: @travel.start_airport, start_city: @travel.start_city, type: @travel.type }
    end

    assert_redirected_to travel_path(assigns(:travel))
  end

  test "should show travel" do
    get :show, id: @travel
    assert_response :success
  end

  test "should get edit" do
    get :edit, id: @travel
    assert_response :success
  end

  test "should update travel" do
    patch :update, id: @travel, travel: { about: @travel.about, arrival_time: @travel.arrival_time, company: @travel.company, departure_time: @travel.departure_time, direct_trip: @travel.direct_trip, end_airport: @travel.end_airport, end_city: @travel.end_city, lowcost: @travel.lowcost, places_available: @travel.places_available, price: @travel.price, start_airport: @travel.start_airport, start_city: @travel.start_city, type: @travel.type }
    assert_redirected_to travel_path(assigns(:travel))
  end

  test "should destroy travel" do
    assert_difference('Travel.count', -1) do
      delete :destroy, id: @travel
    end

    assert_redirected_to travels_path
  end
end
