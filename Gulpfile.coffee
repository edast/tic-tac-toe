gulp = require 'gulp'

coffee = require 'gulp-coffee'
concat = require 'gulp-concat'
uglify = require 'gulp-uglify'
sourcemaps = require 'gulp-sourcemaps'
del = require 'del'

paths =
  scripts: ['coffee/**/*.coffee']

gulp.task 'clean', (cb) ->
  del ['build'], cb
  
  
gulp.task 'scripts', ['clean'], ->
  # Minify and copy all JavaScript (except vendor scripts)
  # with sourcemaps all the way down
  return gulp.src paths.scripts
    .pipe sourcemaps.init()
    .pipe coffee()
    .pipe uglify()
    .pipe concat 'all.min.js'
    .pipe sourcemaps.write()
    .pipe gulp.dest 'build/js'


gulp.task 'watch', ->
  gulp.watch paths.scripts, ['scripts']


gulp.task 'default', ['watch', 'scripts']
