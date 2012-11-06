
_ = require 'underscore'
require 'colors'

options     = require './options'
State       = require './state'
strategies  = require './strategies'

playerPiece = '#'
emptySpace = '-'.grey

playerColor = [
    'red'
    'blue'
    'green'
    'magenta'
]

class Board
    playerIndex: 0
    playerList: [0...options.getOption 'players']

    constructor: ->
        _.bindAll(@)
        @state = new State()
        @_initializePlayers()

    toString: ->
        end = @_makeEnd().white.bold
        rowStrs = @state.map (player) ->
            return emptySpace if _.isUndefined player
            return playerPiece[playerColor[player]].bold
        rowStrs = _.map rowStrs, (row) ->
            row.join ' '
        end + "\n| ".white.bold + rowStrs.join(" |\n| ".white.bold) + " |\n".white.bold + end

    update: ->
        if @playerList.length == 1
            return "Player #{@playerList[0]+1} wins"[playerColor[@playerList[0]]].bold

        player = @playerList[@playerIndex]
        if player == 0
            if @playerList.length == 2
                strat = new strategies.two_player @state, player, @playerList, options.getOption 'lookahead'
            else
                strat = new strategies.multi_player @state, player, @playerList, options.getOption 'lookahead'
        else
            strat = new strategies.random @state, player
        move = strat.search()
        if options.getOption 'verbose'
            col = playerColor[player]
            console.log "player #{player+1}'s move"[col].bold, move
        if move == false
            @playerList = _.filter @playerList, (p) ->
                p != player
            @playerIndex = @playerIndex % @playerList.length
            return @update()
        else
            @state.capture move.x, move.y, player
            @playerIndex = (@playerIndex + 1) % @playerList.length

        return false

    _initializePlayers: ->
        numPlayers = options.getOption 'players'
        for move in [0...3]
            for player in [0...numPlayers]
                @state.setRandomEmptySpaceToPlayer player

    _makeEnd: ->
        result = ''
        pattern = '-'
        width = options.getOption('grid') * 2 + 3

        while width > 0
            result += pattern if width & 1
            width >>= 1
            pattern += pattern

        return result

module.exports = Board