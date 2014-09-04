# Place all the behaviors and hooks related to the matching controller here.
# All this logic will automatically be available in application.js.
# You can use CoffeeScript in this file: http://coffeescript.org/

$(document).ready ->
  $.ajax(
    url: $("pre").data("source")
    context: document.body
  ).done (response) ->
    $("pre").html response
    return
  return




#$(document).ready(function(){
#  $.ajax({
#     url:  $('pre').data('source'),
#      context: document.body,
#   }).done(function(response) {
#  $('pre').html(response);
#  });
#});
