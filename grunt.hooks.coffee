fs   = require 'fs-extra'
path = require 'path'
_    = require 'lodash'

localConfigFile = '.leavesrc.local'
localConfig = null

module.exports = (grunt) ->
  if fs.existsSync localConfigFile
    localConfig = JSON.parse fs.readFileSync(localConfigFile)

  prepareDir = ->
    if fs.existsSync 'parse'
      fs.removeSync 'parse'
    fs.mkdirSync 'parse'
    fs.copySync 'dist', path.join('parse', 'public')
    if fs.existsSync 'cloud'
      fs.copySync 'cloud', path.join('parse', 'cloud')
    else
      fs.mkdirSync path.join('parse', 'cloud')
    fs.mkdirSync path.join('parse', 'config')

    configFile = path.join('parse', 'config', 'global.json')
    fs.writeFileSync configFile, JSON.stringify(localConfig.parse, null, 4)

  grunt.registerTask 'afterCompile', (env) ->
    return if env == 'tmp'
    unless localConfig.parse
      grunt.fail.warn 'Parse config not found. Aborting.'
      return

    prepareDir()

    cloudFiles = fs.readdirSync path.join('parse', 'cloud')
    _.each cloudFiles, (file) ->
      filepath = path.join('parse', 'cloud', file)
      content = fs.readFileSync filepath, 'utf8'
      output = _.template(content)(localConfig)
      fs.writeFileSync filepath, output
