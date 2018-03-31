->
  $('#tabs').tab();

$ ->
  $('.footable').footable(breakpoints: filter: 300)

# ajax spinners

$(document).on "ajax:beforeSend", "*[data-spinner]", (e) ->
  $($(this).data("spinner")).show()
  e.stopPropagation() #Don't show spinner of parent elements.

$(document).on "ajax:complete", "*[data-spinner]", ->
  $($(this).data("spinner")).hide()

# alert box html for js.erb files

@alert_box = (level, close_btn, msg) ->
  if close_btn == 'y'
    html = \
    "<div class='alert fade show alert-#{level}'>
    <button class='close' data-dismiss='alert'>\&times;</button>#{msg}</div>"
  else
    html = \
    "<div class='alert fade show alert-#{level}'>#{msg}</div>"
  return html
