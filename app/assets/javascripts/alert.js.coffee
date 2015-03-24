$(document).ready ->
	$('.alert').alert()
	window.setTimeout (->
	  $('.alert').alert 'close'
	  return
	), 200000
return