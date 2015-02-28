class SearchResults
  def initialize(search)
    @search = search
  end

  def run
    text_data = {
      :from => '14157636769',
      :to => @search.user.cell,
      :body => results_text
    }

    @twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
    @twilio.account.messages.create text_data
  end

  def results_text
    success_places.any? ? success_result_text : fail_result_text
  end

  def success_result_text
    text = "The following retailers currently have #{@search.description} in stock right now :) \n\n"
    success_places.each do |place|
      text += "#{place.name}\n#{place.address} \n\n"
    end
    text += "Cheers"
    text
  end

  def fail_result_text
    text = "Unfortunately, there are no retailers near you that have #{@search.description} in stock :( \n\n"
    text += "Search for other booz "
    text
  end

  def success_places
    @success_places ||= SearchPlace.where(search: @search, result: SearchPlace::IN_STOCK).all.map(&:place)
  end
end
