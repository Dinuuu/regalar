$ ->
  validator = $('form').validate()
  $('#next-button').click  ->
    $('#campaign-tabs a:last').tab('show') if validateInputs($('#first-step').find('input'))
  $('#previous-button').click  ->
    $('#campaign-tabs a:first').tab('show') if validateInputs($('#second-step').find('input'))

  $('.category-card').each( () ->
    $(this).click(() ->
      aux = $(this).find('.inner-card')
      aux.css('background-color', '#40E246')
      $('#category-input').val(aux.data('category'))
      $('.category-card .inner-card').each(() ->
        if aux[0] != $(this)[0]
          $(this).css('background-color', 'silver')
      )
    )
  )

  validateInputs = (inputs) ->
    valid = true
    inputs.each ->
      valid = false if not validator.element(this)
    return valid
