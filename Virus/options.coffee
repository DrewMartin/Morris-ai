_ = require 'underscore'
colors = require 'colors'

optimist = require('optimist')
    .boolean(['i', 'd', 'v'])
    .default(
        f: 1
        n: 5
        l: 4
        i: false
        p: 2
        d: false
        v: false
    )
    .alias(
        f: 'fps'
        n: 'grid'
        i: 'interactive'
        l: 'lookahead'
        p: 'players'
        d: 'debug'
        v: 'verbose'
    )
    .describe('f', 'FPS of the game')
    .describe('n', 'Width and height of the game board')
    .describe('i', 'Interactive mode')
    .describe('p', 'The number of players (2-4)')
    .describe('l', 'The number of moves to look ahead')
    .describe('v', 'Verbose')
    .describe('d', 'Debug mode')
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
        grid:           argv.grid
        players:        argv.players
        fps:            argv.fps
        interactive:    argv.interactive
        debug:          argv.debug
        verbose:        argv.verbose

    if options.debug
        options.interactive = true
        options.verbose = true

    errors = []
    errors.push "Lookahead must be at least 1" if options.lookahead < 1
    errors.push "Minimum board size is 4x4" if options.grid < 4
    errors.push "Maximum board size is 10x10" if options.grid > 10
    errors.push "Minimum number of players is 2" if options.players < 2
    errors.push "Maximum number of players is 4" if options.players > 4

    if errors.length
        console.error "Bad arguments given:".red.bold
        console.error msg.red.bold for msg in errors
        console.error()
        showHelp()
        process.exit 0

parseAndCheckArguments()

exports.getOption = (opt) ->
    options[opt]
