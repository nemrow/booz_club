class SearchController < ApplicationController
  def new
    user = User.find_or_create_by(cell: params["cell"])
    search = Search.create({description: params["description"], user: user})
    places = params["places"].map do |place_data|
      place = Place.find_or_create_by(
        name: place_data[1]["name"],
        address: address_builder(place_data[1]["address"]),
        phone_number: format_phone_number(place_data[1]["phone_number"])
      )
      search.places << place
    end
    BulkCaller.new(search).run
  end

  def format_phone_number(phone_number)
    "1" + phone_number.gsub(/\(|\)|\s|-/, "")
  end

  def address_builder(address_data)
    needed_components = ["street_number", "locality", "route"]
    address = {}
    address_data.each do |address_component|
      matched_component = (address_component[1]["types"] & needed_components)
      address[matched_component.first] = address_component[1]["short_name"] if matched_component.any?
    end
    "#{address['street_number']} #{address['route']}, #{address['locality']}"
  end
end
