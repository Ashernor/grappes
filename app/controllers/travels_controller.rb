class TravelsController < ApplicationController
  before_action :set_travel, only: [:show, :edit, :update, :destroy]

  # GET /travels
  def index
    store_search_params_in_cache(params)
    #retrieve_search_params_from_cookies

    #TODO : do a method for min and max
    @max_price = params[:max_price] || 600 #Travel.pluck(:price).max || 500
    @min_duration = 0  # Travel.pluck(:duration).min || 0
    @max_duration = 24 # Travel.pluck(:duration).max || 12

    @minmax_hour = [0,24] #Travel.pluck(:departure).map{ |e| e.hour}.minmax
    @front_travels = Travel.prefered("ok").empty? ? Travel.all : Travel.prefered("ok")
    @moods = Mood.all.uniq

    @cms = Cms.where(:language == "fr").first

    @citys = []
    @coordinates = {}
    @citys = Airport.where(first_class: true).map {|t|
      @coordinates[t.city] = {lat:t.latitude,lng:t.longitude}
      hash = {}
      hash["value"]       = t.city
      hash["label"]       = "#{t.city} - #{t.iata_code}"

      hash
    }.uniq
    #Qpx::Api.logger.debug "========= Cities = #{@citys.inspect}"
    # Nothing to do until user selected params.
    unless params[:from].present? and params[:min_date].present? and params[:max_date].present?
      Rails.logger.warn "No search to do. Insufficient params: #{params}"
      return
    end

    @travels = params.size == 2 ? nil : Travel.in_budget(0, @max_price)
    puts "=== Params: #{params}"
    puts "=== Initial travels count: "+ @travels.count.to_s
    #TODO: do a method for search
    filter_travel_general_info(params)

    puts "=== General travels count: "+ @travels.count.to_s
    #TODO: do a method for search
    ########## QPX: call api and refilter, unless there is travels filtered. ###########
    #TODO: call API even when Travels are outdated (use the search_date field).
    if @travels.blank? and params[:from].present?
      start_date  = params[:min_date].to_time if params['min_date'].present?
      end_date    = params[:max_date].to_time if params['max_date'].present?
      nb_people   = (params[:nb_people].present?)?params[:nb_people].to_i : 1
      Qpx::Api.multi_search_trips_by_city(params[:from],start_date,end_date,nb_people,@max_price)
      @travels = Travel.in_budget(0, @max_price)
      filter_travel_general_info(params)
      puts "=== After Api Call travels count: "+ @travels.count.to_s
      #TODO: do a method for search
      filter_travel_details(params)
      puts "=== After details filters travels count: "+ @travels.count.to_s
      #TODO: do a method for search
    end
    ########## END QPX ###########

    @stopover = @travels.pluck(:stopover).uniq.sort_by!{ |e| e } if @travels
    @companies = @travels.pluck(:company).uniq if @travels
    @end_countries = @travels.pluck(:end_country).uniq.sort_by!{ |e| e.downcase }.delete_if(&:empty?) if @travels

  end

  def filter_travel_general_info(params)
    @travels = @travels.from(params[:from]) if params[:from].present?
    @travels = @travels.in_budget(params[:min_budget], params[:max_budget]) if (params[:min_budget].present? && params[:max_budget].present?)
    @travels = @travels.with_start_date(params[:min_date]) if params[:min_date].present?
    @travels = @travels.with_end_date(params[:max_date]) if params[:max_date].present?
    @travels = @travels.with_people(params[:nb_people]) if params[:nb_people].present?
  end


  def filter_travel_details(params)
    @travels = @travels.within_duration(params[:min_travel_time], params[:max_travel_time]) if params[:min_travel_time].present?
    @travels = @travels.number_of_stopover(params[:stopover]) if params[:stopover].present?
    #between start time and end_time
    @travels = @travels.within_start_time(params[:min_start_time], params[:max_start_time]) if params[:min_start_time].present?
    @travels = @travels.within_end_time(params[:min_end_time], params[:max_end_time]) if params[:min_end_time].present?
    @travels = @travels.order_by(:price => :asc).limit(50) if @travels
    @travels = @travels.not_in_countries(params[:countries]) if params[:countries].present?
    @travels = @travels.not_in_companies(params[:companies]) if params[:companies].present?
    @travels = @travels.with_mood(params[:mood]) if params[:mood].present?
    # we want to show the cheapest flights first
    @travels.asc(:price) if @travels
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

  def store_search_params_in_cache(params)
    cookies[:from] = { :value => params[:from], :expires => Time.now + 2592000} if params[:from].present?

    cookies[:min_budget] = { :value => params[:min_budget], :expires => Time.now + 2592000} if params[:min_budget].present?
    cookies[:max_budget] = { :value => params[:max_budget], :expires => Time.now + 2592000} if params[:max_budget].present?

    cookies[:min_date] = { :value => params[:min_date], :expires => Time.now + 2592000} if params[:min_date].present?
    cookies[:max_date] = { :value => params[:max_date], :expires => Time.now + 2592000} if params[:max_date].present?
  end

  def retrieve_search_params_from_cookies
    if !cookies[:min_date].blank?
      if cookies[:min_date].to_date >= Date.today
        params[:from] = cookies[:from] if cookies[:from]
        params[:min_budget] = cookies[:min_budget] unless cookies[:min_budget].blank?
        params[:max_budget] = cookies[:max_budget] unless cookies[:max_budget].blank?
        params[:min_date] = cookies[:min_date] unless cookies[:min_date].blank?
        params[:max_date] = cookies[:max_date] unless cookies[:max_date].blank?
      end
    end
  end
end
