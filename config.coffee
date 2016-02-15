path = require 'path'
dist = './dist/'

module.exports =
    scripts:
        source: [
            './src/coffee/options.coffee'
            './src/coffee/popup.coffee'
            './src/coffee/background.coffee'
            './src/coffee/contentscript.coffee'
            './src/coffee/chromereload.coffee'
        ]
        extensions: ['.coffee']
        transforms: ['coffeeify', 'envify']
        commonFile: 'common.js'
        destination: path.join(dist, 'js')
    templates:
        source: './src/jade/*.jade'
        watch: './src/jade/*.jade'
        destination: dist
    styles:
        source: './src/stylus/style.styl'
        watch: './src/stylus/*.styl'
        destination: path.join(dist, 'css')
    assets:
        source: [
            './src/assets/**/*.*'
        ]
        watch: [
            './src/assets/**/*.*'
        ]
        destination: dist
    manifest:
        source: './src/manifest.cson'
        watch: './src/manifest.cson'
        destination: dist
    locales:
        source: './src/_locales/**/*.cson'
        watch: './src/_locales/**/*.cson'
        destination: path.join(dist, '_locales')
    destination: dist