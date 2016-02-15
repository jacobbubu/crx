browserify          = require 'browserify'
bundler             = require 'gulp-watchify-factor-bundle'
browserSync         = require('browser-sync').create()
chalk               = require 'chalk'
CSSmin              = require 'gulp-cssnano'
filter              = require 'gulp-filter'
gulp                = require 'gulp'
gutil               = require 'gulp-util'
jade                = require 'gulp-jade'
path                = require 'path'
prefix              = require 'gulp-autoprefixer'
prettyTime          = require 'pretty-hrtime'
source              = require 'vinyl-source-stream'
sourcemaps          = require 'gulp-sourcemaps'
stylus              = require 'gulp-stylus'
uglify              = require 'gulp-uglify'
watchify            = require 'watchify'
buffer              = require 'vinyl-buffer'
size                = require 'gulp-size'
notify              = require 'gulp-notify'
ignore              = require 'gulp-ignore'
livereload          = require 'gulp-livereload'

path                = require 'path'
cson                = require './gulp-cson'
config              = require './config'
updateManifest      = require './updateManifest'

process.env.NODE_ENV ?= 'development'
production   = process.env.NODE_ENV is 'production'

handleError = (err) ->
    gutil.log err
    gutil.beep()
    @emit 'end'

gulp.task 'manifest', ->
    excludeScripts = if production then ['js/chromereload.js'] else []

    gulp.src config.manifest.source
    .pipe cson()
    .on 'error', handleError
    .pipe buffer()
    .pipe updateManifest excludeScripts: excludeScripts
    .pipe gulp.dest config.manifest.destination

gulp.task 'assets', ->
    gulp.src config.assets.source
        .pipe gulp.dest config.assets.destination

gulp.task 'templates', ->
    pipeline = gulp
        .src config.templates.source
        .pipe jade
            pretty: not production

        .on 'error', handleError
        .pipe gulp.dest config.templates.destination
    # pipeline = pipeline.pipe browserSync.reload(stream: true) unless production
    pipeline

gulp.task 'locales', ->
    gulp.src config.locales.source
        .pipe cson()
        .on 'error', handleError
        .pipe gulp.dest config.locales.destination

gulp.task 'liveUpdated', ['manifest'], ->
    livereload.reload()

gulp.task 'watch', (done) ->
    livereload.listen()
    # to instead of 'gulp-watchify-factor-bundle''s watch method
    # for hacking update event
    watcher = (bundle, watchifyOpts, done) ->
        if typeof done is 'function'
            watchifyOpts
        else if typeof watchifyOpts is 'function'
            done = watchifyOpts
            watchifyOpts = null

        b = bundle._b
        b._options.cache = b._options.cache ? {}
        b._options.packageCache = b._options.packageCache ? {}
        b = watchify b, watchifyOpts
        b.on 'update', (changedFiles)->
            gutil.log "Starting '#{chalk.cyan 'rebundle'}'..."
            start = process.hrtime()
            bundle ->
                gutil.log "Finished '#{chalk.cyan 'rebundle'}' after #{chalk.magenta prettyTime process.hrtime start}"
                done?(changedFiles)
        # build once before any update
        bundle()

    gulp.watch config.manifest.watch, ['manifest']
        .on 'change', livereload.reload
    gulp.watch config.templates.watch, ['templates', 'manifest']
        .on 'change', livereload.reload
    gulp.watch config.assets.watch, ['assets', 'manifest']
        .on 'change', livereload.reload
    gulp.watch config.locales.watch, ['locales', 'manifest']
        .on 'change', livereload.reload

    watcher bundle, ->
        gulp.start 'liveUpdated'

gulp.task 'mkdirp', ->
    gulp.src './src/.'
        .pipe config.destination

bundle = do (scriptConfig=config.scripts) ->
    entries = scriptConfig.source
    b = browserify
        entries: entries
        extensions: scriptConfig.extensions
        debug: not production
        transform: scriptConfig.transforms
        plugin: []

    bundler b,
    {
        entries: entries
        outputs: entries.map (f) -> path.basename(f, '.coffee') + '.js'
        common: scriptConfig.commonFile
    },
    (bundleStream) ->
        result = bundleStream
            .on 'error', gutil.log.bind gutil, 'Browserify Error'
            .pipe buffer()
            .pipe sourcemaps.init loadMaps: true

        result = result.pipe uglify() if production
        result = result.pipe sourcemaps.write '.'

        if production
            result
                .pipe ignore.exclude '*.map'
                .pipe size showFiles: true
                .pipe size showFiles: true, gzip: true

        result.pipe gulp.dest scriptConfig.destination

gulp.task 'scripts', bundle

gulp.task 'no-js', ['templates', 'assets', 'manifest', 'locales']

gulp.task 'build', ['scripts', 'no-js']

gulp.task 'default', ['no-js'], -> gulp.start 'watch'