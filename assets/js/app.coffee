window.App ?= {}

App.openPage = (page) ->
  $('.back, .header').addClass('opened')
  $('.content').removeClass('opened')
  $(".content.#{page}").addClass('opened')
  ga('send', 'pageview', page)

App.closePage = ->
  $('.back, .header, .content').removeClass('opened')
  ga('send', 'pageview', '/')

App.initializeHeader = ->
  App.MainVue = new Vue
    el: '.header'
    data: {page: null}
    methods:
      opened: -> !_.isEmpty(page)
      open: (page) -> App.openPage(page)
      close: -> App.closePage()

App.initialize = ->
  hash = window.location.hash.substr(1)
  App.openPage hash unless _.isEmpty(hash)
  App.initializeHeader()
  App.initializeContactForm()

$ ->
  App.initialize()
