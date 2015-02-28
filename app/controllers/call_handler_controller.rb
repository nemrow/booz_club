class CallHandlerController < ApplicationController
  skip_before_action :verify_authenticity_token

  def init_call
    @search = Search.find(params["search_id"])
    place = Place.find(params["place_id"])
    search_place = SearchPlace.find_by(search: @search, place: place)
    search_place.update(steps_completed: SearchPlace::CALL_ANSWERED)
    @post_to = ENV['BASE_URL'] + "/handle_response?place_id=#{place.id}&search_id=#{@search.id}"
    render action: "init_call.xml.builder", :layout => false
  end

  def status_callback
    search = Search.find(params["search_id"])
    search_place = SearchPlace.find_by(search: search, place_id: params["place_id"])
    search_place.update(recording_url: params["RecordingUrl"])
    if search_place.result == nil
      if search_place.steps_completed == SearchPlace::CALL_ANSWERED
        search_place.update(result: SearchPlace::HANGUP)
      else
        search_place.update(result: SearchPlace::NO_ANSWER)
      end
    end
    check_for_search_completion(search)
    render :nothing => true
  end

  def handle_response
    search = Search.find(params["search_id"])
    place = Place.find(params["place_id"])
    search_place = SearchPlace.find_by(search: search, place: place)
    if params['Digits'] == '1'
      search_place.update(result: SearchPlace::IN_STOCK, steps_completed: SearchPlace::CALL_RESPONDED)
      render action: 'goodbye.xml.builder', :layout => false
    end

    if params['Digits'] == '2'
      search_place.update(result: SearchPlace::NOT_IN_STOCK, steps_completed: SearchPlace::CALL_RESPONDED)
      render action: 'goodbye.xml.builder', :layout => false
    end

    check_for_search_completion(search)
  end

  private

  def check_for_search_completion(search)
    if search_complete?(search) && search.complete != true
      search.update(complete: true)
      SearchResults.new(search).run
    end
  end

  def search_complete?(search)
    SearchPlace.where(search: search).all? {|sp| sp.result != nil}
  end
end
