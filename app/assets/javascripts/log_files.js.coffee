# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $.ajax(
    url: $("pre.log-file").data("source")
    context: document.body
  ).done (response) ->
    $("pre.log-file").html response
    return
  return

$(document).ready ->
  $("input[name='log_file[access_type_id]']").change ->
    $(this).closest(".form-group").next().next().find(".alert-info").hide(0).html($("#AccessTypeID" + $(this).val()).html()).fadeIn "fast"
    return
  return


