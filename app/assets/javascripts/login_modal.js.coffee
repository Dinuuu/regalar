$(document).ready ->
  $("#user_email").keyup (e) ->
    $("#login-modal").find("form").submit()  if e.keyCode is 13
    return
  $("#user_password").keyup (e) ->
    $("#login-modal").find("form").submit()  if e.keyCode is 13
    return
