
read = require 'read'

options = require './options'
Board = require './board'

frameRate = Math.floor 1000/options.getOption 'fps'

showPrompt = (prompt, done) ->
    read {prompt}, (err, input) ->
        if err or /^q/.test input
            console.log "Goodbye!"
            return process.exit 0
        done()

gameLoop = (board) ->
    start = new Date()
    res = board.update()
    if options.getOption 'verbose'
        finish = new Date()
        console.log "Took", (finish-start), "ms to update"

    console.log board.toString()

    if res
        console.log res
        process.exit 0

    onFinish = ->
        gameLoop board

    if options.getOption 'interactive'
        showPrompt "Enter q to quit, anything else to update: ", onFinish
    else
        setTimeout onFinish, Math.max(frameRate, 0)

board = new Board()

console.log board.toString()

showPrompt "Press enter to start or q to quit: ", ->
    gameLoop board
