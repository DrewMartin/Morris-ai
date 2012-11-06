
require 'colors'
vsprintf    = require('sprintf').vsprintf
_           = require 'underscore'

options     = require './options'
State       = require './state'
strategies  = require './strategies'
layout      = require './layout'
phases      = require './phases'

playerPiece = 'O'.bold
emptySpace  = '#'.grey

playerColor = [
    'red'
    'blue'
]

class Board
    nextPlayer: 0

    constructor: ->
        _.bindAll(@)
        @state = new State()

    toString: ->
        positions = @state.map (pos) ->
            return emptySpace if _.isUndefined pos
            return playerPiece[playerColor[pos]]

        return vsprintf layout.boardStr, positions

    update: ->
        player = @nextPlayer
        if player == 0
            strat = new strategies.diff @state, player, [0, 1], options.getOption 'lookahead'
        else
            strat = new strategies.div @state, player, [1, 0], options.getOption 'lookahead'
        move = strat.search()
        if !move
            winner = (player + 1) % 2
            return "Player #{winner+1} wins!"[playerColor[winner]].bold + (" Player #{player+1} has no moves"[playerColor[player]].bold)

        if options.getOption 'verbose'
            console.log "Player #{player+1}'s move:"[playerColor[player]].bold, move

        @state.doMove move, player
        @nextPlayer = (player + 1) % 2

        playerCount = @state.countPiecesByPlayer()
        if @state.getCurrentPhase() == phases.SHIFT_PHASE
            for p in [0...playerCount.length]
                if playerCount[p] == 0
                    winner = (p + 1) % 2
                    return "Player #{winner+1} wins!"[playerColor[winner]].bold
        else if playerCount[0] + playerCount[1] == 24
            return "The game is a draw!"

        return

module.exports = Board
