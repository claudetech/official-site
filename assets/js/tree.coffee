class App.Tree
  constructor: (@name, @children=[]) ->
    @parent = null
    _.each @children, (child) =>
      child.parent = this

  path: ->
    [path, parent] = ["#{@name}", @parent]
    while parent?
      path = "/#{parent.name}" + path
      parent = parent.parent
    if _.isEmpty(path) then "/" else path
