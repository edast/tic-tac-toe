gulp = require 'gulp'

coffee = require 'gulp-coffee'
del = require 'del'
browserify = require 'browserify'
runSequence = require 'run-sequence'
coffeeify = require 'coffeeify'
source = require 'vinyl-source-stream'

paths =
  scripts: ['coffee/**/*.coffee']

gulp.task 'clean', (cb) ->
  del ['build'], cb
  
COFFEE_DIR = "#{__dirname}/coffee/"

browserifyOpts = 
  derequire: false
  basedir: COFFEE_DIR
  extensions: ['.coffee']
  paths: [COFFEE_DIR]
  entries: "#{COFFEE_DIR}/app.coffee"
  commondir: false
  fullPaths: false
  debug: false
  insertGlobals: false
  detectGlobals: false
  
  
gulp.task 'scripts', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  browserify browserifyOpts
    .transform('coffeeify')
    .bundle()
    .pipe source 'all.min.js'
    .pipe gulp.dest 'build/js'

gulp.task 'watch', (cb) ->
  runSequence 'scripts', ->
  js = gulp.watch paths.scripts, ['scripts']
  js.on 'change', changeReport

changeReport = (event) ->
  console.log "  [#{event.type}] #{event.path}"


gulp.task 'default', ->
  runSequence 'scripts'
