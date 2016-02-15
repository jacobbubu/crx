Cycle = require '@cycle/core'
{div, label, input, hr, h1, makeDOMDriver} = require '@cycle/dom'
{Observable} = require 'rx'

console.log 'options'

main = (sources) ->
    dom$ = sources.DOM.select('.field').events 'input'
            .map (ev) ->
                ev.target.value
            .startWith ''
            .map (name) ->
                div [
                    label 'Name:'
                    input '.field', attributes: type: 'text'
                    hr()
                    h1 'Hello ' + name
                ]

    sinks =
        DOM: dom$

Cycle.run main, DOM: makeDOMDriver('#container')