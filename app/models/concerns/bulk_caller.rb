class BulkCaller
  def initialize(search)
    @search = search
  end

  def run
    @search.places.each do |place|
      data = {
        :to => place.phone_number,
        # to: "17078496085",
        from: "14157636769",
        record: true,
        if_machine: "Hangup",
        status_callback: ENV["BASE_URL"] + "/status_callback?place_id=#{place.id}&search_id=#{@search.id}",
        url: ENV["BASE_URL"] + "/init_call?place_id=#{place.id}&search_id=#{@search.id}"
      }
      search_place = SearchPlace.find_by(search: @search, place: place)
      begin
        @twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
        @twilio.account.calls.create data
        search_place.update(steps_completed: SearchPlace::CALL_PLACED)
      rescue Exception => e
        search_place.destroy
        puts "ERROR TRYING TO CALL #{place.name} with id #{place.id} for search id #{@search.id}. #{e}"
      end
    end
  end
end
