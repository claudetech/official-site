$ ->
  $('.menu a').click (e) ->
    e.preventDefault()
    e.stopPropagation()
    $('.back, .header').addClass('opened')
    $('.content').removeClass('opened')
    $('.content.' + $(this).attr('href')).addClass('opened')
    
