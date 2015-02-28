class BulkCaller
  def initialize(search)
    @search = search
  end

  def run
    @search.places.each do |place|
      data = {
        # :to => place.phone_number
        to: "17078496085",
        from: "14157636769",
        url: ENV["BASE_URL"] + "/init_call?place_id=#{place.id}&search_id=#{@search.id}"
      }

      @twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
      @twilio.account.calls.create data
    end
  end
end
