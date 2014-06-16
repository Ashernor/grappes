# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.travelsJs =

  init: ->
    $(".datepicker").datepicker();
    availableTags = $(".city").data("city")
    $(".autocomplete").autocomplete {
      source: availableTags
    }

    $(".city_search form input").keydown ->
      content = $(this).val().length
      #if (content > 3)
        #$('.city_search form').submit();

    min_budget = $("#min_budget").val()
    max_budget = $("#max_budget").val()
    if (min_budget == "")
      min_budget = 75
    if (max_budget == "")
      max_budget = 300

    $( "#slider-range" ).slider {
      range: true,
      min: 0,
      max: 500,
      values: [min_budget, max_budget],
      slide: (event, ui) ->
        $("#min_budget").val(ui.values[ 0 ]);
        $("#max_budget").val(ui.values[ 1 ]);
        $("#amount").text(ui.values[ 0 ] + " - " + ui.values[ 1 ])
    }

    citys = []
    $(".end_city").each ->
      citys.push($(this).text())

    mapOptions = {
      center: new google.maps.LatLng( 48.861954, 2.270895600000017),
      zoom: 3
    }
    map = new google.maps.Map(document.getElementById("map"), mapOptions);

    geocoder = new google.maps.Geocoder
    for city in citys
      console.log(city)
      geocoderParams =
        address: city
      results = geocoder.geocode geocoderParams, (results, status) ->
        if status == google.maps.GeocoderStatus.OK
          latlng = results[0].geometry.location
          marker = new google.maps.Marker
            position: latlng
            map: map

