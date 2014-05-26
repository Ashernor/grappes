class TravelsController < ApplicationController
  before_action :set_travel, only: [:show, :edit, :update, :destroy]

  # GET /travels
  def index
    @travels = Travel.all
    @travels = @travels.from(params[:from]) if params[:from].present?
    @travels = @travels.in_budget(params[:min_budget], params[:max_budget]) if params[:min_budget].present?
    @travels = @travels.between_dates(params[:min_date], params[:max_date]) if params[:min_date].present? && params[:max_date].present?
    @travels = @travels.with_people(params[:nb_people]) if params[:nb_people].present?
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
    Product.import(params[:file])
    redirect_to root_url, notice: "Products imported."
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
