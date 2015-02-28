$('.test-post').click (e) ->
  e.preventDefault()
  data = {
    "description": "Greygoose Vodka",
    "cell": "17078496085",
    "places": {
      "0": {
        "name": "Jordans Place",
        "address": {
          "0": {
            "long_name": "99",
            "short_name": "99",
            "types": [
              "street_number"
            ]
          },
          "1": {
            "long_name": "Marina Boulevard",
            "short_name": "Marina Boulevard",
            "types": [
              "route"
            ]
          },
          "2": {
            "long_name": "San Francisco",
            "short_name": "SF",
            "types": [
              "locality",
              "political"
            ]
          },
          "3": {
            "long_name": "California",
            "short_name": "CA",
            "types": [
              "administrative_area_level_1",
              "political"
            ]
          },
          "4": {
            "long_name": "United States",
            "short_name": "US",
            "types": [
              "country",
              "political"
            ]
          },
          "5": {
            "long_name": "94123",
            "short_name": "94123",
            "types": [
              "postal_code"
            ]
          }
        },
        "types": [
          "liquor_store",
          "food",
          "store",
          "bar",
          "establishment"
        ],
        "phone_number": "(707) 849-6085"
      },
      "1": {
        "name": "Dans Place",
        "address": {
          "0": {
            "long_name": "99",
            "short_name": "99",
            "types": [
              "street_number"
            ]
          },
          "1": {
            "long_name": "Marina Boulevard",
            "short_name": "Marina Boulevard",
            "types": [
              "route"
            ]
          },
          "2": {
            "long_name": "San Francisco",
            "short_name": "SF",
            "types": [
              "locality",
              "political"
            ]
          },
          "3": {
            "long_name": "California",
            "short_name": "CA",
            "types": [
              "administrative_area_level_1",
              "political"
            ]
          },
          "4": {
            "long_name": "United States",
            "short_name": "US",
            "types": [
              "country",
              "political"
            ]
          },
          "5": {
            "long_name": "94123",
            "short_name": "94123",
            "types": [
              "postal_code"
            ]
          }
        },
        "types": [
          "liquor_store",
          "food",
          "store",
          "bar",
          "establishment"
        ],
        "phone_number": "(916) 521-1306"
      }
    }
  }
  $.post('/search', data)
