$(document).ready ->
	$('.alert').alert()
	window.setTimeout (->
	  $('.alert').alert 'close'
	  return
	), 2000
return