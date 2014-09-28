class App.CommandHandler
  constructor: ->
    @root = new App.Tree('', [
      new App.Tree('news')
      new App.Tree('about', [
        new App.Tree('jobs')
      ])
      new App.Tree('service')
      new App.Tree('team')
      new App.Tree('access')
      new App.Tree('contact')
    ])
    @cwd = @root

  handle: (line) ->
    [command, args...] = line.split(' ')
    switch command
      when 'ls' then @handleLs(args)
      when 'cd' then @handleCd(args)
      when 'pwd' then @cwd.path()
      else @handleUndefined(command)

  handleUndefined: (command) ->
    "claudetech: command not found: #{command}"

  handleCd: (args) ->
    "cd:cd: string not found in pwd: #{args[0]}" if args.length > 1
    oldDir = @cwd
    err = @cd(args?[0] ? '')
    if _.isEmpty(err)
      if @cwd.path() == '/'
        App.closePage()
      else
        App.openPage(@cwd.name)
      ''
    else
      @cwd = oldDir unless _.isEmpty(err)
      err

  cd: (path) ->
    [dir, left...] = path.split('/')
    [@cwd, err] = switch dir
      when '.'  then [@cwd, null]
      when ''   then [@root, null]
      when '..' then [(if @cwd.parent? then @cwd.parent else @cwd), null]
      else
        d = _.find @cwd.children, {name: dir}
        if d? then [d, null] else [@cwd, "cd:cd: no such file or directory: #{dir}"]
    return err if err?
    if _.isEmpty(left) then '' else @cd(left.join('/'))

  handleLs: (args) ->
    _.map(@cwd.children, (v) -> v.name).join('\t')
