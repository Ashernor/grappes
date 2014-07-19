# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.travelsJs =
  init: ->
    options =
      format: 'dd-mm-yyyy',
      monthNames:['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Decembre'],
      monthNamesShort: ['Janv.','Févr.','Mars','Avril','Mai','Juin',
                        'Juil.','Août','Sept.','Oct.','Nov.','Déc.'],
      dayNames: ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'],
      dayNamesShort: ['Dim.','Lun.','Mar.','Mer.','Jeu.','Ven.','Sam.'],
      dayNamesMin: ['D','L','M','M','J','V','S']
    $(".datepicker").datepicker(options);
    availableTags = $("#travel_list").data("cities")
    $(".autocomplete").autocomplete {
      source: availableTags
    }

    $(".city_search form input").keydown ->
      content = $(this).val().length
      #if (content > 3)
        #$('.city_search form').submit();

    # submit when modif finished
    # Price range
    min_budget = $("#min_budget").val()
    max_budget = $("#max_budget").val()
    min_budget = 75 if (min_budget == "")
    max_budget = 300 if (max_budget == "")
    tooltip1 = $('<div id="tooltip_left" class="tooltip" />').text(min_budget+"€")
    tooltip2 = $('<div id="tooltip_right" class="tooltip" />').text(max_budget+"€")
    $( "#slider-range" ).slider {
      range: true,
      min: 0,
      max: 500,
      values: [min_budget, max_budget],
      slide: (event, ui) ->
        $("#min_budget").val(ui.values[0])
        $("#max_budget").val(ui.values[1])
        tooltip1.text(ui.values[0]+"€")
        tooltip2.text(ui.values[1]+"€")
    },
    stop: ->
      $(this).parent().parent().find("form").addClass("modified")
      $(this).parent().parent().find("form").submit()
    $(".price_range .ui-slider-handle").eq(0).append(tooltip1)
    $(".price_range .ui-slider-handle").eq(1).append(tooltip2)

    # travel time range
    min_travel_time = $("#min_travel_time").val()
    max_travel_time = $("#max_travel_time").val()
    min_travel_time = 2 if (min_travel_time == "")
    max_travel_time = 6 if (max_travel_time == "")
    tooltip3 = $('<div id="tooltip_left" class="tooltip" />').text(min_travel_time+"h")
    tooltip4 = $('<div id="tooltip_right" class="tooltip" />').text(max_travel_time+"h")
    $( "#slider-range-travel" ).slider {
      range: true,
      min: 0,
      max: 10,
      values: [min_travel_time, max_travel_time],
      slide: (event, ui) ->
        $("#min_travel_time").val(ui.values[0])
        $("#max_travel_time").val(ui.values[1])
        tooltip3.text(ui.values[0]+"h")
        tooltip4.text(ui.values[1]+"h")
    },
    stop: ->
      $(this).parent().parent().find("form").addClass("modified")
      $(this).parent().parent().find("form").submit()
    $(".travel_time .ui-slider-handle").eq(0).append(tooltip3)
    $(".travel_time .ui-slider-handle").eq(1).append(tooltip4)

    #within_start_time
    this.createCustomTimeSlider($("#slider-range-start"), $("#min_start_time"), $("#max_start_time"), 540, 1240, $(".within_time .start"), "h")
    #within_end_time
    this.createCustomTimeSlider($("#slider-range-end"), $("#min_end_time"), $("#max_end_time"), 540, 1240, $(".within_time .end"), "h")

    $( "#accordion" ).accordion(
      icons: {
        header: "iconClosed",
        heightStyle: "content",
        collapsible: true,
        autoHeight: false,
        clearStyle: true,
        activeHeader: "iconOpen"
      }
    );
    $("#accordion > div").css({ 'height': 'auto' });

    $("#left_button").click ->
      if ($("#sidebar_left").hasClass("active"))
        lessormore = "-"
      else
        lessormore = "+"
      $("#map").animate({"margin-left": lessormore+'=200'});
      $("#sidebar_left, #left_button").animate({"left": lessormore+'=200'});
      $("#sidebar_left").toggleClass("active");
      $("#left_button").toggleClass("active");
      return false;

    $("#right_button").click ->
      if ($("#sidebar_right").hasClass("active"))
        lessormore = "-"
        contrary = "+"
      else
        lessormore = "+"
        contrary = "-"
      $("#map").animate({"margin-left": contrary+'=360'});
      $("#sidebar_right, #right_button").animate({"right": lessormore+'=360'});
      $("#sidebar_right").toggleClass("active");
      $("#right_button").toggleClass("active");
      return false;

  geoMap: ->
    map = L.mapbox.map('map', 'examples.h186knp8', { zoomControl:false }).setView([48.32, 2.5], 5)

    myLayer = L.mapbox.featureLayer().addTo(map)

    myLayer.on 'layeradd', (e) ->
      marker = e.layer
      feature = marker.feature
      popupContent =  '<div class="left"><h4>'+feature.properties.end_city+'</h4>'+'<img src="' + feature.properties.image + '" /><span class="blurred"></span><p>'+feature.properties.content+'</p></div><div class="right"><ul class="start"><li><span class="start_date">'+feature.properties.start_date+'</span><br/><b>'+feature.properties.start_city+'</b><br/><b>'+feature.properties.end_city+'</b></li><li class="company">'+feature.properties.company+'<br/><span class="hours">'+feature.properties.start_departure_time+'- '+feature.properties.start_arrival_time+'</span></li></ul><ul class="end"><li><span class="end_date">'+feature.properties.end_date+'</span><br/><b>'+feature.properties.end_city+'</b><br/><b>'+feature.properties.start_city+'</b></li><li class="company">'+feature.properties.company+'<br/><span class="hours">'+feature.properties.start_departure_time+'- '+feature.properties.start_arrival_time+'</span></li></ul></div><div class="bottom">Reserver ce trajet pour <span>'+feature.properties.price+'</span><div></div>'
      marker.bindPopup popupContent,
        closeButton: false
        minWidth: 320
      marker.setIcon(L.divIcon(feature.properties.divIcon));
      #myLayer.on 'mouseover', (e) ->
      #  marker = e.layer
      #  marker.openPopup()
      #myLayer.on 'mouseover', (e) ->
      #  e.layer.closePopup()

    geoJson = []
    geoJson = this.parseContent()
    myLayer.setGeoJSON(geoJson);

    parent = this

    $("form input").change ->
      $(this).parent().addClass("modified") if $(this).parent().attr("method") == "get"
      $(this).parent().parent().addClass("modified") if $(this).parent().parent().attr("method") == "get"
      if parseInt( $("#nb_people").val()) > 1
        $(".price_range span").text("Budget par personne")
      else
        $(".price_range span").text("Budget")
      loadParams()

    $("form").submit (e) ->
      loadParams()
      e.preventDefault()

    $("#sidebar_right li .open_pin").click ->
      $("#right_button").click()
      title = $(this).parent().find(".city").data("city")
      clickButton(title)
      return false;

    $("#reset_filter").click (e) ->
      $(".modified input").val("")
      loadParams()
      e.preventDefault()

    loadParams= ->
      params = "/?"+$(".modified").serialize().replace(/\utf8=%E2%9C%93&/g,"")+" #travel_list"
      $("#loader").load(params, ->
        geoJson = parent.parseContent()
        myLayer.setGeoJSON(geoJson)
      )

    clickButton= (city) ->
      myLayer.eachLayer (marker) ->
        if (marker.feature.properties.title == city)
          marker.openPopup();


  createCustomSlider: (slider_id, min, max, min_slider, max_slider, parent, type) ->
    min_value = $(min).val()
    max_value = $(max).val()
    min_value = 2 if (min_value == "")
    max_value = 6 if (max_value == "")
    tooltip1 = $('<div id="tooltip_left" class="tooltip" />').text(min_value+type)
    tooltip2 = $('<div id="tooltip_right" class="tooltip" />').text(max_value+type)
    $(slider_id).slider {
      range: true,
      min: min_slider,
      max: max_slider,
      values: [min_value, max_value],
      slide: (event, ui) ->
        $(this).parent().parent().find("form").addClass("modified")
        tooltip1.text(ui.values[0]+type)
        tooltip2.text(ui.values[1]+type)
    }
    $(parent).find(".ui-slider-handle").eq(0).append(tooltip1)
    $(parent).find(".ui-slider-handle").eq(1).append(tooltip2)

  createCustomTimeSlider: (slider_id, min, max, min_slider, max_slider, parent, type) ->
    min_value = $(min).val()
    max_value = $(max).val()
    min_value = min_slider if (min_value == "")
    max_value = max_slider if (max_value == "")
    tooltip1 = $('<div id="tooltip_left" class="tooltip" />').text("9h0")
    tooltip2 = $('<div id="tooltip_right" class="tooltip" />').text("20h30")
    $(slider_id).slider {
      range: true,
      min: 0,
      max: 1440,
      step: 15,
      values: [min_value, max_value],
      slide: (event, ui) ->
        hours1 = Math.floor((ui.values[0] / 60))
        minutes1 = (ui.values[0] - (hours1 * 60))
        hours1 = '0' + hours1 if(hours1.length == 1)
        minutes1 = '0' + minutes1 if(minutes1.length == 1)
        time1 = hours1+"h"+minutes1
        hours2 = Math.floor((ui.values[1] / 60))
        minutes2 = (ui.values[1] - (hours2 * 60))
        hours2 = '0' + hours if(hours1.length == 1)
        minutes2 = '0' + minutes if(minutes2.length == 1)
        time2 = hours2+"h"+minutes2
        tooltip1.text(time1)
        tooltip2.text(time2)
        $(min).val(parseFloat(hours1+"."+minutes1))
        $(max).val(parseFloat(hours2+"."+minutes2))
    },
    stop: ->
      $(this).parent().parent().find("form").addClass("modified")
      $(this).parent().parent().find("form").submit()
    $(parent).find(".ui-slider-handle").eq(0).append(tooltip1)
    $(parent).find(".ui-slider-handle").eq(1).append(tooltip2)

  parseContent: ->
    geoJson = []
    $("#travel_list li").each ->
      if $(this).data("coordinates") != ""
        coordinates = $(this).data("coordinates")
        company = $(this).data("company")
        color = $(this).data("color")
        start_airport = $(".city", this).data("startairport")
        end_airport = $(".city", this).data("endairport")
        start_city = $(".city", this).data("startcity")+" <span>("+start_airport+")</span>"
        end_city = $(".city", this).data("endcity")+" <span>("+end_airport+")</span>"
        price = $(".price span", this).text()
        start_date = $(".start", this).html().slice(0, - 9)
        end_date = $(".end", this).html().slice(0, - 9)
        content = $(this).data("content")
        start_departure_time = $(this).data("starttime").toString().replace(".","h")
        start_arrival_time = $(this).data("endtime").toString().replace(".","h")
        geo = {
          type: 'Feature',
          "geometry": { "type": "Point", "coordinates": coordinates},
          "properties": {
            "image": "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Cherry_Blossoms_and_Washington_Monument.jpg/320px-Cherry_Blossoms_and_Washington_Monument.jpg",
            "start_city": start_city,
            "start_airport": start_airport,
            "end_city": end_city,
            "end_airport": end_airport,
            "title": end_city,
            "price": price,
            "company": company,
            "start_date": start_date,
            "end_date": end_date,
            "content": content,
            "start_departure_time": start_departure_time,
            "start_arrival_time": start_arrival_time,
            "divIcon": {
              "iconSize": [50, 50],
              "iconAnchor": [25, 25],
              "className": "count-icon "+color,
              "html": price
            }
          }
        }
        geoJson.push(geo);
    return geoJson
