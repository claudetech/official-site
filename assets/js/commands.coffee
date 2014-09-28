class App.CommandHandler
  constructor: ->
    @commands = ['ls', 'cd', 'pwd']
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

  getCompletion: (term, string, callback) ->
    callback(@commands)

  handleUndefined: (command) ->
    "claudetech: command not found: #{command}"

  handleCd: (args) ->
    "cd:cd: string not found in pwd: #{args[0]}" if args.length > 1
    oldDir = @cwd
    err = @cd(args?[0] ? '')
    return err unless _.isEmpty(err)
    if @cwd.path() == '/'
      App.closePage()
    else
      App.openPage(@cwd.name)
    ''

  cd: (path) ->
    dir = @_getNode(path)
    if dir?
      @cwd = dir
      ''
    else
      "cd:cd: no such file or directory: #{path}"

  handleLs: (args) ->
    node = if _.isEmpty(args) then @cwd else @_getNode(args[0])
    _.map(node.children, (v) -> v.name).join('\t')

  _getNode: (path, current=@cwd) ->
    [dir, left...] = path.split('/')
    nextDir = switch dir
      when '.'  then current
      when ''   then @root
      when '..' then (if current.parent? then current.parent else current)
      else
        d = _.find current.children, {name: dir}
        if d? then d else null
    return null unless nextDir?
    if _.isEmpty(left) then nextDir else @_getNode(left.join('/'), nextDir)
