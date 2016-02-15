through2 = require 'through2'

start = 0
module.exports = (opt={}) ->
    opt.excludeScripts ?= []

    through2.obj (vinyl, enc, cb) ->
        obj = JSON.parse vinyl.contents.toString()
        verSegs = obj.version.split '.'
        last = verSegs.length - 1

        if start is 0
            if isNaN Number(verSegs[last])
                start = 1
            else
                start = Number verSegs[last]
        else
            start++
            if isNaN Number(verSegs[last])
                verSegs.push start
            else
                verSegs[last] = start
            obj.version = verSegs.join '.'

        if obj.background?.scripts?
            opt.excludeScripts.forEach (jsFile) ->
                index = obj.background.scripts.indexOf jsFile
                if index >= 0
                    obj.background.scripts.splice index, 1

        vinyl.contents = new Buffer JSON.stringify(obj, null, 4)
        @push vinyl
        cb()