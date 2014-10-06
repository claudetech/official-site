livereloadPort = 35729
httpServerPort = 9000

fs         = require 'fs'
path       = require 'path'
loremIpsum = require 'lorem-ipsum'
_          = require 'lodash'

extraConfigFile = '.leavesrc'

extraConfig = {}
if fs.existsSync extraConfigFile
  extraConfig = JSON.parse fs.readFileSync(extraConfigFile, 'utf8')

localesDir = extraConfig.i18n?.localesDir ? 'locales'

lorem = (count, options={}) ->
  if typeof count == 'number'
    options.count = count
  else
    options = count ? {}
  options.units ?= 'words'
  loremIpsum options


cssFiles = [
  expand: true
  cwd: 'assets'
  src: ['css/**/*.styl', '!css/**/_*.styl']
  dest: 'tmp'
  ext: '.css'
]
cssDistFiles = [_.extend({}, cssFiles[0], {dest: 'dist'})]

templateFiles = [
  expand: true
  cwd: 'views'
  src: ['**/*.jade', '!**/_*.jade', '!layout.jade']
  dest: 'tmp'
  ext: '.html'
]
templateDistFiles = [_.extend({}, templateFiles[0], {dest: 'dist'})]

coffeeFiles = [
  expand: true
  cwd: 'assets'
  src: ['js/**/*.coffee']
  dest: 'tmp'
  ext: '.js'
]
coffeeDistFiles = [_.extend({}, coffeeFiles[0], {dest: 'dist'})]

htmlFiles = [
  expand: true
  cwd: 'tmp'
  src: ['**/*.html']
  dest: 'tmp'
  ext: '.html'
]
htmlDistFiles = [_.extend({}, htmlFiles[0], {dest: 'dist', cwd: 'dist'})]

i18n = false

i18nOptions =
  tmp:
    options:
      baseDir: 'tmp'
      outputDir: 'tmp'
  dev: {}
  dist: {}
  options:
    fileFormat: 'yml'
    baseDir: 'dist'
    outputDir: 'dist'
    exclude: ['components/']
    locales: []
    locale: 'en'
    localesPath: 'locales'

if fs.existsSync i18nOptions.options.localesPath
  files = fs.readdirSync i18nOptions.options.localesPath
  unless _.isEmpty(files)
    i18n = true
    i18nOptions.options.locales = _.map files, (f) -> f.substring(0, f.lastIndexOf('.'))

if extraConfig?.i18n?
  _.merge i18nOptions.options, extraConfig.i18n

Array::push.apply i18nOptions.options.exclude, _.map(i18nOptions.options.locales, (l) -> l + '/')

module.exports = (grunt) ->
  require('load-grunt-tasks')(grunt)

  grunt.initConfig
    pkg: grunt.file.readJSON 'package.json'

    watch:
      assets:
        files: ['assets/**/*', '!assets/css/**/*.styl','!assets/js/**/*.coffee']
        tasks: ['newer:copy:tmpAssets']
        options:
          event: ['changed']
      assetsGlob:
        files: ['assets/**/*', '!assets/css/**/*.styl', '!assets/js/**/*.coffee']
        tasks: ['copy:tmpAssets', 'views:tmp:true']
        options:
          event: ['added', 'deleted']
      coffee:
        cwd: 'assets/js'
        files: 'assets/js/**/*.coffee'
        tasks: ['brerror:newer:coffee:tmp']
        options:
          event: ['changed']
      coffeeGlob:
        cwd: 'assets/js'
        files: 'assets/js/**/*.coffee'
        tasks: ['brerror:newer:coffee:tmp', 'views:tmp:true']
        options:
          event: ['added', 'deleted']
      stylesheets:
        cwd: 'assets/css'
        files: 'assets/css/**/*.styl'
        tasks: ['brerror:newer:stylus:tmp']
        options:
          event: ['changed']
      stylesheetsGlob:
        cwd: 'assets/css'
        files: 'assets/css/**/*.styl'
        tasks: ['brerror:newer:stylus:tmp', 'views:tmp:true']
        options:
          event: ['added', 'deleted']
      views:
        cwd: 'views'
        files: 'views/**/*.jade'
        tasks: ['views:tmp:true:true']
      locales:
        files: "#{i18nOptions.options.localesPath}/**/*.#{i18nOptions.options.fileFormat}"
        tasks: ['views:tmp:true']
      options:
        livereload: livereloadPort

    coffee:
      tmp:
        files: coffeeFiles
      dev:
        files: coffeeDistFiles
      dist:
        files: coffeeDistFiles


    stylus:
      tmp:
        files: cssFiles
        options:
          compress: false
      dev:
        files: cssDistFiles
        options:
          compress: false
      dist:
        files: cssDistFiles
      options:
        use: [
          require 'axis'
        ]

    jade:
      tmp:
        files: templateFiles
        options:
          pretty: true
      dev:
        files: templateDistFiles
        options:
          pretty: true
      dist:
        files: templateDistFiles
      options:
        data:
          lorem: lorem

    connect:
      server:
        options:
          port: httpServerPort
          keepalive: true
          debug: true
          base: 'tmp'
          useAvailablePort: true
          open: true
          livereload: true

    copy:
      tmpAssets:
        expand: true
        cwd: 'assets'
        src: ['**/*', '!css/**/*.styl', '!js/**/*.coffee']
        dest: 'tmp'
      tmpComponents:
          expand: true
          cwd: '.components'
          src: ['**/*', '!**/src/**']
          dest: 'tmp/components'
      dist:
        files: [
          expand: true
          cwd: '.components'
          src: ['**/*', '!**/src/**']
          dest: 'dist/components'
        ,
          expand: true
          cwd: 'assets'
          src: ['**/*', '!css/**/*.styl', '!js/**/*.coffee']
          dest: 'dist'
        ]

    concurrent:
      start:
        tasks: ['connect', 'watch', 'brerror:server']
        options:
          logConcurrentOutput: true
          gruntPath: path.join __dirname, 'node_modules', 'grunt-cli', 'bin', 'grunt'

    newer:
      options:
        override: (detail, include) ->
          cwdPath = grunt.config("#{detail.task}.#{detail.target}.files.0.cwd")
          return include() unless cwdPath?
          cwd = path.join __dirname, cwdPath
          baseFile = path.join __dirname, detail.path
          content = fs.readFileSync baseFile, 'utf8'
          compile = needsCompile cwd, baseFile, detail.time, content
          include(compile)

    clean:
      tmp: ['tmp']
      dist: ['dist']
      dev: ['dist']

    glob:
      tmp:
        files: htmlFiles
      dev:
        files: htmlDistFiles
      dist:
        files: htmlDistFiles
        options:
          concat: true
          minify: true

    cdnify:
      tmp:
        files: htmlFiles
        options:
          useLocal: true
      dev:
        files: htmlDistFiles
        options:
          useLocal: true
      dist:
        files: htmlDistFiles
      options:
        incompatible: ['glob']

    i18n: i18nOptions


  needsCompile = (file, baseFile, time, content) ->
    stat = fs.statSync file
    if stat.isDirectory()
      dirFiles = fs.readdirSync(file)
      for f in dirFiles
        filepath = path.join file, f
        return true if needsCompile filepath, baseFile, time, content
    else
      return false if file == baseFile || stat.mtime > time
      filename = path.basename(file)
      word = filename.substr(0, filename.lastIndexOf('.'))
      return true if content.indexOf(word) > -1
    return false

  mapFile = (filepath) ->
    filepath = filepath.replace /^(assets|views)/, 'tmp'
    filepath = filepath.replace /\.styl$/, '.css'
    filepath = filepath.replace /\.coffee$/, '.js'
    filepath = filepath.replace /\.jade$/, '.html'
    filepath

  grunt.event.on 'watch', (event, file, task) ->
    return unless event == 'deleted'
    filepath = path.join __dirname, mapFile(file)
    grunt.file.delete(filepath) if fs.existsSync filepath


  grunt.registerTask 'makeCopy', (env) ->
    if env == 'tmp'
      grunt.task.run ["copy:tmpAssets", "copy:tmpComponents"]
    else
      grunt.task.run ["copy:dist"]


  grunt.registerTask 'views', (env, brerror, useNewer) ->
    prefixes = []
    prefixes.push 'brerror' if brerror
    prefixes.push 'newer' if useNewer
    prefix = prefixes.join(':')
    prefix += ':' unless _.isEmpty(prefix)
    tasks = [
      "#{prefix}jade:#{env}"
      "cdnify:#{env}"
      "glob:#{env}"
    ]
    tasks.push "i18n:#{env}" if i18n
    grunt.task.run tasks


  grunt.registerTask 'compile', 'Compiles the website', (env) ->
    grunt.task.run [
      "clean:#{env}"
      "makeCopy:#{env}"
      "coffee:#{env}"
      "stylus:#{env}"
      "views:#{env}"
    ]

  grunt.registerTask 'default', ['compile:tmp', 'concurrent:start']
