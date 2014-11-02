$ ->
  $('#accept_invite').submit( (event) ->
    value = $(event.target).find('input[name="townsman[name]"]').val()
    if value == ""
      return false
    else
      return true
  )
