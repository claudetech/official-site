window.App ?= {}

App.openPage = (page) ->
  $('.back, .header').addClass('opened')
  $('.content').removeClass('opened')
  $(".content.#{page}").addClass('opened')
  $('.language-selector').addClass('opened')
  App.LangVue.hash = "##{page}"
  ga('send', 'pageview', page)

App.closePage = ->
  $('.back, .header, .content').removeClass('opened')
  $('.language-selector').removeClass('opened')
  App.LangVue.hash = ''
  ga('send', 'pageview', '/')

App.initializeHeader = ->
  App.MainVue = new Vue
    el: '.header'
    data: {page: null}
    methods:
      opened: -> !_.isEmpty(page)
      open: (page) -> App.openPage(page)
      close: -> App.closePage()

  App.LangVue = new Vue
    el: '.language-selector'
    data:
      hash: window.location.hash

App.initialize = ->
  hash = window.location.hash.substr(1)
  App.initializeHeader()
  App.initializeContactForm()
  App.openPage hash unless _.isEmpty(hash)

$ ->
  App.initialize()
