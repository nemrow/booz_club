class SearchController < ApplicationController
  def new
    user = User.find_or_create_by(cell: params["cell"])
    search = Search.create({description: params["description"], user: user})
    return false if obscenity?(search)
    params["places"].each do |place_data|
      if place_data[1]["phone_number"] && place_data[1]["address"] && place_data[1]["name"]
        place = Place.find_or_create_by(
          name: place_data[1]["name"],
          address: address_builder(place_data[1]["address"]),
          phone_number: format_phone_number(place_data[1]["phone_number"])
        )
        search.places << place
      end
    end
    if search.places.any?
      search.update(location: basic_search_location_builder(params["places"].first[1]["address"]))
      BulkCaller.new(search).run
    end
    check_for_high_search_traffic
  end

  def obscenity?(search)
    if Obscenity.profane?(search.description)
      search.update(cancelled: "obscenity")
      send_search_rejected_message(search)
      true
    end
  end

  def send_search_rejected_message(search)
    text_data = {
      :from => '14157636769',
      :to => search.user.cell,
      :body => "Your search \"#{search.description}\" has been flagged as innapropriate. We have cancelled this search."
    }

    @twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
    @twilio.account.messages.create text_data
  end

  def check_for_high_search_traffic
    send_high_traffic_alert_text if number_of_searches_in_past_hour == 25
  end

  def send_high_traffic_alert_text
    text_data = {
      :from => '14157636769',
      :to => ENV['EMERGENCY_CELL_NUMBER'],
      :body => "Booz.club has had a high number of searches in the past hour. CHECK ON IT!"
    }

    @twilio = Twilio::REST::Client.new ENV['TWILIO_SID'], ENV['TWILIO_AUTH_TOKEN']
    @twilio.account.messages.create text_data
  end

  def number_of_searches_in_past_hour
    Search.where("created_at > ?", Time.now - 1.hours).count
  end

  def format_phone_number(phone_number)
    formatted_num = "1" + phone_number.gsub(/\(|\)|\s|-/, "")
    formatted_num.match(/^1\d{10}/)[0]
  end

  def basic_search_location_builder(address_data)
    needed_components = ["locality", "administrative_area_level_1"]
    address = {}
    address_data.each do |address_component|
      matched_component = (address_component[1]["types"] & needed_components)
      address[matched_component.first] = address_component[1]["short_name"] if matched_component.any?
    end
    "#{address['locality']}, #{address['administrative_area_level_1']}"
  end

  def address_builder(address_data)
    needed_components = ["street_number", "locality", "route"]
    address = {}
    address_data.each do |address_component|
      if address_component[1]["types"]
        matched_component = (address_component[1]["types"] & needed_components)
        address[matched_component.first] = address_component[1]["short_name"] if matched_component.any?
      end
    end
    "#{address['street_number']} #{address['route']}, #{address['locality']}"
  end
end
