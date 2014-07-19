class TravelsController < ApplicationController
  before_action :set_travel, only: [:show, :edit, :update, :destroy]

  # GET /travels
  def index
    @travels = Travel.all
    # TODO : better search handling
    @travels = @travels.from(params[:from]) if params[:from].present?
    @travels = @travels.in_budget(params[:min_budget], params[:max_budget]) if params[:min_budget].present?
    @travels = @travels.between_dates(params[:min_date], params[:max_date]) if params[:min_date].present? && params[:max_date].present?
    @travels = @travels.with_people(params[:nb_people]) if params[:nb_people].present?
    @travels = @travels.within_duration(params[:min_travel_time], params[:max_travel_time]) if params[:min_travel_time].present?
    @travels = @travels.number_of_stopover(params[:stopover]) if params[:stopover].present?
    @travels = @travels.with_companies(params[:company]) if params[:company].present?
    #between start time and end_time
    @travels = @travels.within_start_time(params[:min_start_time], params[:max_start_time]) if params[:min_start_time].present?
    @travels = @travels.within_end_time(params[:min_end_time], params[:max_end_time]) if params[:min_end_time].present?


    @travels = @travels.order_by(:price => :asc).limit(50)

    @citys = Travel.all.map(&:start_city).uniq
    @front_travels = Travel.prefered("ok").empty? ? Travel.all : Travel.prefered("ok")
    @companies = Travel.all.pluck(:company).uniq
    @moods = Mood.all
    @end_countries = Travel.all.pluck(:end_country).uniq

  end

  # GET /travels/1
  def show
  end

  # GET /travels/new
  def new
    @travel = Travel.new
  end

  # GET /travels/1/edit
  def edit
  end

  # POST /travels
  def create
    @travel = Travel.new(travel_params)

    if @travel.save
      redirect_to @travel, notice: 'Travel was successfully created.'
    else
      render action: 'new'
    end
  end

  # PATCH/PUT /travels/1
  def update
    if @travel.update(travel_params)
      redirect_to @travel, notice: 'Travel was successfully updated.'
    else
      render action: 'edit'
    end
  end

  # DELETE /travels/1
  def destroy
    @travel.destroy
    redirect_to travels_url, notice: 'Travel was successfully destroyed.'
  end

  def import
    Travel.import(params[:file])
    redirect_to '/admin/travel', notice: "Travels imported."
  end

  private
    # Use callbacks to share common setup or constraints between actions.
    def set_travel
      @travel = Travel.find(params[:id])
    end

    # Only allow a trusted parameter "white list" through.
    def travel_params
      params.require(:travel).permit(:start_city, :end_city, :price, :places_available, :about, :departure_time, :arrival_time, :direct_trip, :company, :lowcost, :type, :start_airport, :end_airport)
    end
end
