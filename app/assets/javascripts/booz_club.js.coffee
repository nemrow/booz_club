placesArray = []
placesCount = null

runFinder = (data={}) ->
  placesArray = []
  placesCount = null

  data = {
    lat: "37.805620"
    long: "-122.431898"
    radius: "500"
  }

  @latLng = new google.maps.LatLng(data.lat, data.long)
  @map = new google.maps.Map($('#map-node')[0], {center: @latLng, zoom: 15})

  nearbyRequestData = {
    location: @latLng
    radius: data.radius
    types: ['liquor_store']
  }

  @placesService = new google.maps.places.PlacesService(@map)

  @placesService.nearbySearch(nearbyRequestData, nearbyCallback)

nearbyCallback = (results, status) ->
  placesCount = results.length
  for place in results
    @placesService.getDetails({placeId: place.place_id}, detailCallback)

detailCallback = (place, status) ->
  placesArray.push neededPlaceAttrs(place) if status == "OK"
  placesSearchComplete() if --placesCount == 0

neededPlaceAttrs = (place) ->
  name: place.name
  address: place.address_components
  types: place.types
  phone_number: place.formatted_phone_number

placesSearchComplete = () ->
  placesNames = placesArray.map (place) ->
    place.name

  swal("We're checking #{placesNames.length} places!", placesNames.join(', '), "success")

  data = {
    description: "Greygoose Vodka"
    cell: "17078496085"
    places: placesArray
  }
  $.post '/search', data


# Handle form submission
$('#find-form').submit (e) ->
  e.preventDefault()
  runFinder()


######## GET THE CURRENT LOCATIONNN

# initializeLocation = (pos) ->
#   @latLng = new google.maps.LatLng(pos.coords.latitude, pos.coords.longitude)

# locationError = (err) ->
#   console.warn('ERROR(' + err.code + '): ' + err.message)


# navigator.geolocation.getCurrentPosition(initializeLocation, locationError, mapOptions)
