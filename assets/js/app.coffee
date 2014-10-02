window.App ?= {}

App.openPage = (page) ->
  $('.back, .header').addClass('opened')
  $('.content').removeClass('opened')
  $(".content.#{page}").addClass('opened')

App.closePage = ->
  $('.back, .header, .content').removeClass('opened')

$ ->
  hash = window.location.hash.substr(1)
  if(hash != '')
    $('.back, .header').addClass('opened')
    $(".content.#{hash}, .back").addClass('opened')

  $('.logo').click (e) ->
    e.preventDefault()
    e.stopPropagation()
    App.closePage()

  $('.menu a').click (e) ->
    App.openPage($(this).attr('href').substr(1))
