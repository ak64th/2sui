autoprefixer = require('gulp-autoprefixer')
browserSync = require('browser-sync').create()
cssnano = require 'gulp-cssnano'
gulp = require 'gulp'
gutil = require 'gulp-util'
rename = require 'gulp-rename'
sass = require 'gulp-sass'
sourceMaps = require 'gulp-sourcemaps'

PATH =
  APP: './app'
  DIST: './dist'

PATH.INDEX = "#{PATH.APP}/index.html"
PATH.STYLES = "#{PATH.APP}/styles"
PATH.CSS = "#{PATH.DIST}/css"

process.env.NODE_ENV ?= gutil.env.mode or 'development'
mode = process.env.NODE_ENV

handleError = (error) ->
  gutil.log error.toString()
  browserSync.notify "Browserify Error"
  @emit 'end'

gulp.task 'html', ->
  gulp.src PATH.INDEX
    .pipe gulp.dest PATH.DIST

gulp.task 'reload-html', ['html'], -> browserSync.reload()


gulp.task 'style', ->
  gulp.src "#{PATH.STYLES}/**/*.{scss,sass}"
    .pipe sourceMaps.init()
    .pipe sass()
    .on 'error', handleError
    .pipe autoprefixer {browsers: '> 1% in CN, iOS 7'}
    .pipe sourceMaps.write './'
    .pipe gulp.dest PATH.CSS
    .pipe browserSync.stream()

gulp.task 'watch', ['html'], ->
  gulp.watch PATH.INDEX, ['reload-html']
  gulp.watch "#{PATH.STYLES}/**/*.{scss,sass}", ['style']

gulp.task 'server', ['watch'], ->
  browserSync.init
    open: true
    server:
      baseDir: PATH.DIST

gulp.task 'default', ['html']
