# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $("input.date-picker").datepicker
    dateFormat: "yy-mm-dd"
    onSelect: (date) ->
      if $(this).attr("name").indexOf("gteq") > 0
        $("input.date-picker[name='q[search_statistic_start_date_lteq]']").datepicker "option", "minDate", date
      else
        $("input.date-picker[name='q[search_statistic_start_date_gteq]']").datepicker "option", "maxDate", date


