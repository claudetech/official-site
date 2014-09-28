class App.Tree
  constructor: (@name, @children=[]) ->
    @parent = null
    _.each @children, (child) =>
      child.parent = this

  path: ->
    return "/" unless @parent?
    [path, parent] = [[@name], @parent]
    while parent?
      path.unshift(parent.name)
      parent = parent.parent
    path.join('/')
