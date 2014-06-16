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

    tooltip1 = $('<div id="tooltip_left" class="tooltip" />').text(min_budget+"€")
    tooltip2 = $('<div id="tooltip_right" class="tooltip" />').text(max_budget+"€")
    $( "#slider-range" ).slider {
      range: true,
      min: 0,
      max: 500,
      values: [min_budget, max_budget],
      slide: (event, ui) ->
        tooltip1.text(ui.values[0]+"€")
        tooltip2.text(ui.values[1]+"€")
    }
    $(".ui-slider-handle").eq(0).append(tooltip1)
    $(".ui-slider-handle").eq(1).append(tooltip2)

  geoMap: ->
    map = L.mapbox.map('map', 'examples.h186knp8').setView([35.32, 25], 3)
    myLayer = L.mapbox.featureLayer().addTo(map)
    myLayer.on 'layeradd', (e) ->
      marker = e.layer
      feature = marker.feature
      popupContent =  '<a target="_blank" class="popup" href="' + feature.properties.url + '">' +
        '<img src="' + feature.properties.image + '" />' +
        feature.properties.city +
        '</a>'
      marker.bindPopup popupContent,
        closeButton: false
        minWidth: 320
    geoJson = []
    $("table tr").each ->
      if $(".coordinates", this).text() != ""
        coordinates = JSON.parse($(".coordinates", this).text())
        city = $(".city", this).text()
        geo = {
          type: 'Feature',
          "geometry": { "type": "Point", "coordinates": coordinates},
          "properties":
            {
            "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Cherry_Blossoms_and_Washington_Monument.jpg/320px-Cherry_Blossoms_and_Washington_Monument.jpg",
            "url": "https://en.wikipedia.org/wiki/Washington,_D.C.",
            "marker-symbol": "star",
            "marker-color": "#ff8888",
            "marker-size": "large",
            "city": city
            }
        }
        geoJson.push(geo)

    myLayer.setGeoJSON(geoJson);
