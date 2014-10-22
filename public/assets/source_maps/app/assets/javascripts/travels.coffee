# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.travelsJs =
  init: ->
    parent = this
    if $("#travel_list li").length == 0
      $("#travel_list").append("<p>Pas de résultat</p>")

    getJson = (url) ->
      $.getJSON "#{url}"

    #geolocation
    maPosition= (position) ->
      pos = []
      pos.push position.coords.latitude
      pos.push position.coords.longitude
      getJson("https://maps.googleapis.com/maps/api/geocode/json?latlng=#{pos[0]},#{pos[1]}").done (e) ->
        results = e.results[0]
        city = ""
        for i in [0..results.address_components.length]
          ac = results.address_components[i]
          if ac
            city = ac.long_name if(ac.types.indexOf("locality") >= 0)
        $("#from").val(city).change()
    noPosition = () ->
      $("#from").attr("placeholder","Ville de départ")

    if(navigator.geolocation && $("#from").val() == "")
      navigator.geolocation.getCurrentPosition(maPosition, noPosition)

    options =
      dateFormat: 'dd/mm/yy',
      monthNames:['Janvier', 'Février', 'Mars', 'Avril', 'Mai', 'Juin', 'Juillet', 'Août', 'Septembre', 'Octobre', 'Novembre', 'Décembre'],
      monthNamesShort: ['Janv.','Févr.','Mars','Avril','Mai','Juin',
                        'Juil.','Août','Sept.','Oct.','Nov.','Déc.'],
      dayNames: ['Dimanche','Lundi','Mardi','Mercredi','Jeudi','Vendredi','Samedi'],
      dayNamesShort: ['Dim.','Lun.','Mar.','Mer.','Jeu.','Ven.','Sam.'],
      dayNamesMin: ['D','L','M','M','J','V','S'],
      minDate: 0
    $(".datepicker").datepicker(options);
    $("#min_date").change ->
      val = $("#min_date").val().split('/')
      if $("#min_date").val() != ""
        date = new Date(val[1]+"/"+parseInt(val[0])+"/"+val[2])
        date.setDate(date.getDate()+1)
        $("#max_date").val($.datepicker.formatDate('dd/mm/yy', date))

    # submit when modif finished
    # Price range
    min_b = $("#min_budget").val()
    max_b = $("#max_budget").val()
    if ((min_b == "") || (max_b == ""))
      min_budget = 75
    else
      min_budget = min_b
    if ((min_b == "") || (max_b == ""))
      max_budget = 300
    else
      max_budget = max_b
    max = 0
    max_v = $(".price_range").data("max")
    if (max_v < max_budget)
      max = max_v
    else
      max = max_budget
    tooltip1 = $('<div id="tooltip_left" class="tooltip" />').text(min_budget+"€")
    tooltip2 = $('<div id="tooltip_right" class="tooltip" />').text(max_budget+"€")
    $( "#slider-range" ).slider {
      range: true,
      min: 0,
      max: parseInt(max),
      values: [min_budget, max_budget],
      slide: (event, ui) ->
        right  = $("#tooltip_right").offset().left
        left   = $("#tooltip_left").offset().left
        if ((right-left) < 37)
          $(this).addClass("fusion")
          unless ui.values[0] < $("#min_budget").val() || ui.values[1] > $("#max_budget").val()
            return false
        else
          $(this).removeClass("fusion")
        $("#min_budget").val(ui.values[0])
        $("#max_budget").val(ui.values[1])
        tooltip1.text(ui.values[0]+"€")
        tooltip2.text(ui.values[1]+"€")
    },
    stop: ->
      $(this).parent().parent().find("form").addClass("modified")
      $(this).parent().parent().find("form").submit()
      parent.changeFromBackground()
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
        if (ui.values[0]+2 >= ui.values[1])
          return false
        $("#min_travel_time").val(ui.values[0])
        $("#max_travel_time").val(ui.values[1])
        tooltip3.text(ui.values[0]+"h")
        tooltip4.text(ui.values[1]+"h")
    },
    stop: ->
      $(this).parent().parent().find("form").addClass("modified")
      $(this).parent().parent().find("form").submit()
      parent.changeFromBackground()
    $(".travel_time .ui-slider-handle").eq(0).append(tooltip3)
    $(".travel_time .ui-slider-handle").eq(1).append(tooltip4)

    min = parseInt($(".within_time").data("minhour"))*60
    max = parseInt($(".within_time").data("maxhour"))*60
    #within_start_time
    this.createCustomTimeSlider($("#slider-range-start"), $("#min_start_time"), $("#max_start_time"), min, max, $(".within_time .start"), "h")
    #within_end_time
    this.createCustomTimeSlider($("#slider-range-end"), $("#min_end_time"), $("#max_end_time"), min, max, $(".within_time .end"), "h")

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
    $("#nb_people").spinner {
      stop: ->
        parent.changeFromBackground()
        if parseInt( $("#nb_people").val()) > 1
          $(".price_range span").text("Budget par personne")
        else
          $(".price_range span").text("Budget")
    }

    $("#left_button").click ->
      if ($("#sidebar_left").hasClass("active"))
        lessormore = "-"
      else
        lessormore = "+"
      $("#sidebar_left, #left_button").animate({"left": lessormore+'=200'})
      $("#sidebar_left").toggleClass("active")
      $("#left_button").toggleClass("active")
      window_width = $(window).width()
      if lessormore=="+"
        $("#map").css("width", window_width+200+"px")
      else
        $("#map").css("width", window_width+"px")
      return false;

    $("#right_button").click ->
      if ($("#sidebar_right").hasClass("active"))
        lessormore = "-"
      else
        lessormore = "+"
      $("#sidebar_right, #right_button").animate({"right": lessormore+'=360'})
      window_width = $(window).width()
      if lessormore=="+"
        $("#map").css("width", window_width+200+"px")
      else
        $("#map").css("width", window_width+"px")
      $("#sidebar_right").toggleClass("active")
      $("#right_button").toggleClass("active")
      return false;

  geoMap: ->
    parent = this
    map = L.mapbox.map('map', 'examples.h186knp8', {
      zoomControl: false,
      maxZoom: 12,
      minZoom: 3
    }).setView([48.32, 2.5], 5)
    map.touchZoom.disable();
    map.scrollWheelZoom.disable();
    new L.Control.Zoom({ position: 'bottomright' }).addTo(map);

    myLayer = L.mapbox.featureLayer().addTo(map)

    myLayer.on 'layeradd', (e) ->
      marker = e.layer
      feature = marker.feature
      popupContent =  '<div class="left"><h4>'+feature.properties.end_city+'</h4>'+'<img src="' + feature.properties.image + '" /><span class="blurred"></span><p>'+feature.properties.content+'</p><a class="share" href="#">Partager</a></div><div class="right"><ul class="start"><li><span class="start_date">'+feature.properties.start_date+'</span><br/><b>'+feature.properties.start_city+'</b><br/><b>'+feature.properties.end_city+'</b></li><li class="company">'+feature.properties.company+'<br/><span class="hours">'+feature.properties.start_departure_time+' - '+feature.properties.start_arrival_time+'</span><b class="price">'+feature.properties.price+'</b></li></ul><ul class="end"><li><span class="end_date">'+feature.properties.end_date+'</span><br/><b>'+feature.properties.end_city+'</b><br/><b>'+feature.properties.start_city+'</b></li><li class="company">'+feature.properties.company+'<br/><span class="hours">'+feature.properties.start_departure_time+' - '+feature.properties.start_arrival_time+'</span><b class="price">'+feature.properties.price+'</b></li></ul></div><div class="bottom">Reserver ce trajet pour <span>'+feature.properties.price+'</span><div></div>'
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

    get_json = (url) ->
      $.getJSON "#{url}.json"

    $.marker = L.marker(new L.LatLng(0, 0), {})
    createMarker = (coordinates) ->
      $.marker.setLatLng(L.latLng(
        coordinates["lat"],
        coordinates["lng"]
      ))
      $.marker.addTo(map);
      map.panTo($.marker.getLatLng());
      $("img.leaflet-marker-icon").attr("src","/picto_pin.png").css("width","auto").css("margin-left","-15px").css("margin-top","-37px")

    # autocomplete with ajax submission
    availableTags = $("#travel_list").data("cities")
    $(".autocomplete").autocomplete {
      source: availableTags,
      response: (event,ui) ->
        if (ui.content.length == 1)
          ui.item = ui.content[0].value
          $(this).val(ui.item)
          $(this).autocomplete('close');
        get_json("https://maps.googleapis.com/maps/api/geocode/json?address=#{ui.content[0].value}").done (e) ->
          json = e.results[0].geometry.location
          createMarker(json)
          loadParams()
    }


    $("#from").bind "propertychange keyup input paste", ->
      parent.changeFromBackground()

    $(document).find("input[type='radio']").addClass('radioInactive');

    $(document).on 'click', "input[type='radio']", ->
      # We we can deslect radio buttons
      if $(this).hasClass('radioInactive')
        $(this).prop('checked', true);
      else
        $(this).prop('checked', false);
      $(this).toggleClass('radioInactive')


    $(document).on 'change', 'form input', ->
      parent.changeFromBackground()
      $(this).parent().addClass("modified") if $(this).parent().attr("method") == "get"
      $(this).parent().parent().addClass("modified") if $(this).parent().parent().attr("method") == "get"
      if $(this).hasClass("autocomplete") && $(this).val().length > 3
        get_json("https://maps.googleapis.com/maps/api/geocode/json?address=#{$(this).val()}").done (e) ->
          json = e.results[0].geometry.location
          createMarker(json)
      if $("#from").val().length > 2 && $("#min_date").val().length > 2 && $("#max_date").val().length > 2
        loadParams()

    $("form").submit (e) ->
      loadParams()
      e.preventDefault()

    $(document).on 'click', '#travel_list li', (e) ->
      #$("#right_button").click()
      title = $(this).find(".city").data("endcity")
      clickButton(title)
      e.preventDefault()

    $(document).on 'click', '.open_pin', (e) ->
      #$("#right_button").click()
      title = $(this).parent().find(".city").data("endcity")
      clickButton(title)
      e.preventDefault()

    $("#reset_filter").click (e) ->
      $(".modified input").not(".datepicker, #max_budget, #min_budget, #from").val("").attr('checked', false)
      loadParams()
      # Reset sliders

      min_duration = parseInt($(".travel_time").data("min"))
      max_duration = parseInt($(".travel_time").data("max"))
      resetSlider(".travel_time", min_duration, max_duration, "#{min_duration}h", "#{max_duration}h")

      min = parseInt($(".within_time").data("minhour"))*60
      max = parseInt($(".within_time").data("maxhour"))*60
      #resetSlider(".price_range", 75, 300, "75€", "300€")
      resetSlider(".within_time .start", min, max, translateTimeToText(min), translateTimeToText(max))
      resetSlider(".within_time .end", min, max, translateTimeToText(min), translateTimeToText(max))
      e.preventDefault()

    resetSlider= (element, min_val, max_val, min, max) ->
      $("#{element} .ui-slider").slider('values',0, min_val)
      $("#{element} .ui-slider").slider('values',1, max_val)
      $("#{element} #tooltip_left").text(min)
      $("#{element} #tooltip_right").text(max)

    translateTimeToText=(value) ->
      hours1 = Math.floor(value/60).toString()
      minutes1 = (value - (hours1 * 60)).toString()
      hours1 = '0' + hours1 if hours1.length == 1
      minutes1 = '0' + minutes1 if minutes1.length == 1
      time1 = hours1+"h"+minutes1
      return time1

    loadParams= ->
      params = "/?"+$(".modified").serialize().replace(/\utf8=%E2%9C%93&/g,"")+" #travel_list"
      $("#loader").load(params, ->
        geoJson = parent.parseContent()
        myLayer.setGeoJSON(geoJson)
        if $("#travel_list li").length == 0
          $("#travel_list").append("<p>Pas de résultat</p>")
      )
      form_params = "/?"+$(".modified").serialize().replace(/\utf8=%E2%9C%93&/g,"")
      $(".exclude").load(form_params+" .exclude") unless $(".exclude").hasClass("modified")
      $("form.companies").load(form_params+" form.companies") unless $("form.companies").hasClass("modified")
      $("form.stopover_form").load(form_params+" form.stopover_form") unless $("form.stopover_form").hasClass("modified")

    clickButton= (city) ->
      myLayer.eachLayer (marker) ->
        if (marker.feature.properties.plain_end_city == city)
          marker.openPopup();

  changeFromBackground: ->
    if $("#from").val() == ""
      $("#from").css("background","red")
      $("#from").attr("placeholder", "Renseigne ta ville de départ")
    else
      $("#from").css("background","#fff")
      $("#from").attr("placeholder", "")

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
        if (ui.values[0] == ui.values[1])
          return false
        $(this).parent().parent().find("form").addClass("modified")
        tooltip1.text(ui.values[0]+type)
        tooltip2.text(ui.values[1]+type)
    }
    $(parent).find(".ui-slider-handle").eq(0).append(tooltip1)
    $(parent).find(".ui-slider-handle").eq(1).append(tooltip2)

  createCustomTimeSlider: (slider_id, min, max, min_slider, max_slider, parent, type) ->
    hours1 = Math.floor((min_slider / 60)).toString()
    minutes1 = (min_slider - (hours1 * 60)).toString()
    hours1 = '0' + hours1 if hours1.length == 1
    minutes1 = '0' + minutes1 if minutes1.length == 1
    time1 = hours1+"h"+minutes1

    hours2 = Math.floor((max_slider / 60)).toString()
    minutes2 = (max_slider - (hours2 * 60)).toString()
    hours2 = '0' + hours2 if(hours2.length == 1)
    minutes2 = '0' + minutes2 if(minutes2.length == 1)
    time2 = hours2+"h"+minutes2
    time2 = "00h00" if time2 == "24h0"

    min_value = $(min).val()
    max_value = $(max).val()
    min_value = min_slider if (min_value == "")
    max_value = max_slider if (max_value == "")
    tooltip1 = $('<div id="tooltip_left" class="tooltip" />').text(time1)
    tooltip2 = $('<div id="tooltip_right" class="tooltip" />').text(time2)
    $(slider_id).slider {
      range: true,
      min: 0,
      max: 1440,
      step: 15,
      values: [min_value, max_value],
      slide: (event, ui) ->
        if ((ui.values[0]+120) >= ui.values[1])
          return false
        hours1 = Math.floor((ui.values[0] / 60)).toString()
        minutes1 = (ui.values[0] - (hours1 * 60)).toString()
        hours1 = '0' + hours1 if hours1.length == 1
        minutes1 = '0' + minutes1 if minutes1.length == 1
        time1 = hours1+"h"+minutes1
        hours2 = Math.floor((ui.values[1] / 60)).toString()
        minutes2 = (ui.values[1] - (hours2 * 60)).toString()
        hours2 = '0' + hours2 if(hours2.length == 1)
        minutes2 = '0' + minutes2 if(minutes2.length == 1)
        time2 = hours2+"h"+minutes2
        time2 = "00h00" if time2 == "24h0"
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
        plain_end_city = $(".city", this).data("endcity")
        price = $(".price span", this).text()
        start_date = $(".start", this).html().slice(0, - 9)
        end_date = $(".end", this).html().slice(0, - 9)
        content = $(this).data("content")
        start_departure_time = $(this).data("starttime").toString().replace(".","h")
        start_arrival_time = $(this).data("endtime").toString().replace(".","h")
        image = $(this).data("imageurl")
        image = "https://upload.wikimedia.org/wikipedia/commons/thumb/e/ef/Cherry_Blossoms_and_Washington_Monument.jpg/320px-Cherry_Blossoms_and_Washington_Monument.jpg" if $(this).data("imageurl") == "/images/medium/missing.png"
        geo = {
          type: 'Feature',
          "geometry": { "type": "Point", "coordinates": coordinates},
          "properties": {
            "image": image,
            "start_city": start_city,
            "start_airport": start_airport,
            "end_city": end_city,
            "plain_end_city": plain_end_city,
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
              "iconSize": [70, 30],
              "iconAnchor": [33, 38],
              "className": "count-icon "+color,
              "html": price
            }
          }
        }
        geoJson.push(geo);
    return geoJson
