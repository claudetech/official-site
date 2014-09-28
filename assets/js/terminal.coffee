class App.TerminalHandler
  constructor: ->
    window.terminal = @terminal = $('#terminal').terminal (command, term) =>
      output = @commandHandler.handle(command)
      term.echo(output)
    ,
      greetings: 'Welcome to ClaudeTech'
      name: 'claudetech'
      prompt: '> '
      height: 400
      width: $(window).width() / 3
      hidden: true
    @terminal.disable()
    @visible = false
    @commandHandler = new App.CommandHandler()

  toggle: ->
    @terminal.enable()
    @terminal.slideToggle('fast')
    @visible = !@visible
    @terminal.focus(@visible)

$ ->
  t = new App.TerminalHandler()
  $(window).on 'keyup', (e) ->
    $focus = $(':focus')
    return if $focus.is('textarea') || $focus.is('input')
    if !t.visible && e.which == 84
      t.toggle()
      e.preventDefault()
      e.stopPropagation()
    else if t.visible && e.which == 27
      t.toggle()
