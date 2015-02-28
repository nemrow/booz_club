class CallHandlerController < ApplicationController
  skip_before_action :verify_authenticity_token

  def init_call
    @search = Search.find(params["search_id"])
    @post_to = ENV['BASE_URL'] + "/handle_response?place_id=#{params['place_id']}&search_id=#{params['search_id']}"
    render action: "init_call.xml.builder", :layout => false
  end

  def status_callback
    search = Search.find(params["search_id"])
    search_place = SearchPlace.find_by(search: search, place_id: params["place_id"])
    search_place.update(recording_url: params["RecordingUrl"])
    search_place.update(result: false) if search_place.result == nil

    SearchResults.new(search).run if search_complete?(search)
    render :nothing => true
  end

  def handle_response
    search = Search.find(params["search_id"])
    place = Place.find(params["place_id"])
    search_place = SearchPlace.find_by(search: search, place: place)
    if params['Digits'] == '1'
      search_place.update(result: true)
      render action: 'goodbye_success.xml.builder', :layout => false
    end

    if params['Digits'] == '2'
      search_place.update(result: false)
      render action: 'goodbye_fail.xml.builder', :layout => false
    end

    SearchResults.new(search).run if search_complete?(search)
  end

  private

  def search_complete?(search)
    SearchPlace.where(search: search).all? {|sp| sp.result != nil}
  end
end
