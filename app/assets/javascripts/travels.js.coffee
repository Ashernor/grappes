# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

window.travelsJs =

  init: ->
    $(".datepicker").datepicker();

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

    $( "#amount" ).text( $( "#slider-range" ).slider( "values", 0 ) +
      " - " + $( "#slider-range" ).slider( "values", 1 ) );

