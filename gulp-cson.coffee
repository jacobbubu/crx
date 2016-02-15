through2 = require 'through2'
rext = require 'replace-ext'
cson = require 'cson'

module.exports = (options = {}) ->
    options.indent ?= 4
    options.tab = !!options.tab
    space = if options.tab then '\t' else options.indent

    through2.obj (file, enc, cb) ->
        json = cson.parse file.contents.toString(), options
        return cb json if json instanceof Error

        file.contents = new Buffer JSON.stringify json, null, space
        file.path = rext file.path, '.json'
        @push file
        cb()