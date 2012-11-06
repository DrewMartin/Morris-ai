_ = require 'underscore'
colors = require 'colors'

optimist = require('optimist')
    .boolean(['i', 't', 'd', 'v'])
    .default(
        f: 1
        l: 4
        i: false
        t: false
        d: false
        v: false
    )
    .alias(
        f: 'fps'
        i: 'interactive'
        l: 'lookahead'
        t: 'twelve'
        d: 'debug'
        v: 'verbose'
    )
    .describe('f', 'FPS of the game')
    .describe('i', 'Interactive mode')
    .describe('l', 'The number of moves to look ahead')
    .describe('v', 'Verbose')
    .describe('d', 'Debug mode')
    .describe('t', 'Play twelve men\'s morris')
    .describe('help', 'Show this message')

options = {}

showHelp = ->
    optimist.showHelp()

parseAndCheckArguments = ->
    argv = optimist.argv
    if argv.help
        showHelp()
        return process.exit 0

    options =
        lookahead:      argv.lookahead
        fps:            argv.fps
        twelve:         argv.twelve
        interactive:    argv.interactive
        debug:          argv.debug
        verbose:        argv.verbose

    if options.debug
        options.interactive = true
        options.verbose = true

    errors = []
    errors.push "Lookahead must be at least 1" if options.lookahead < 1

    if errors.length
        console.error "Bad arguments given:".red.bold
        console.error msg.red.bold for msg in errors
        console.error()
        showHelp()
        process.exit 0

parseAndCheckArguments()

exports.getOption = (opt) ->
    options[opt]
