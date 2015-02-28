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

      @twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
      @twilio.account.calls.create data
    end
  end
end
