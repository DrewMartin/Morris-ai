
_ = require 'underscore'
options = require './options'

isEmpty = (thing) ->
    _.isUndefined(thing) or _.isNull(thing)

class State
    gridSize: options.getOption 'grid'

    constructor: ->
        _.bindAll(@)
        @grid = _.map [0...@gridSize], =>
            new Array(@gridSize)

    clone: ->
        state = new State()
        @_forEachSpace (x, y) =>
            state.grid[x][y] = @grid[x][y] if !isEmpty @grid[x][y]

        return state

    capture: (x, y, player) ->
        @_validatePlayer player
        if !@_isPositionOnBoard x, y
            throw "Position (#{x}, #{y}) is not on the board"
        if !@_isValidMove x, y, player
            throw "Move (#{x}, #{y}) is not valid"

        @_capturePriv x, y, player
        @_capturePriv x+1, y, player
        @_capturePriv x-1, y, player
        @_capturePriv x, y+1, player
        @_capturePriv x, y-1, player

    enumMovesForPlayer: (player) ->
        moves = []
        @_forEachSpace (x, y) =>
            moves.push {x, y} if @_isValidMove x, y, player
        return moves


    isMoveUseful: (x, y, player) ->
        a = (x, y, player) =>
            return false if !@_isPositionOnBoard x, y
            return @grid[x][y] != player

        return a(x, y, player) or a(x + 1, y, player) or
            a(x - 1, y, player) or a(x, y + 1, player) or
            a(x, y - 1, player)

    map: (cb) ->
        ((cb col for col in row) for row in @grid)

    numSpacesControlledByPlayers: ->
        numPlayers = options.getOption 'players'
        spaces = (0 for p in [0...numPlayers])

        @_forEachSpace (x, y) =>
            pos = @grid[x][y]
            spaces[pos]++ if !isEmpty pos
        return spaces

    setRandomEmptySpaceToPlayer: (player) ->
        @_validatePlayer player

        emptySpaces = @_enumEmptySpaces()

        space = emptySpaces[_.random(emptySpaces.length - 1)]
        @grid[space.x][space.y] = player

    _isValidMove: (x, y, player) ->
        return false if !@_isPositionOnBoard x, y

        o = @_isOccupiedByPlayer
        return o(x-1, y-1, player) or o(x-1, y, player) or o(x-1, y+1, player) \
            or o(x  , y-1, player) or o(x  , y, player) or o(x  , y+1, player) \
            or o(x+1, y-1, player) or o(x+1, y, player) or o(x+1, y+1, player)

    _capturePriv: (x, y, player) ->
        return if x < 0 or y < 0 or x >= @gridSize or y >= @gridSize

        @grid[x][y] = player

    _enumEmptySpaces: ->
        emptySpaces = []
        @_forEachSpace (x, y) =>
            emptySpaces.push {x, y} if isEmpty @grid[x][y]

        return emptySpaces

    _forEachSpace: (cb) ->
        for x in [0...@gridSize]
            for y in [0...@gridSize]
                cb(x, y)

    _isOccupiedByPlayer: (x, y, player) ->
        return false if !@_isPositionOnBoard x, y
        return @grid[x][y] == player

    _isPositionOnBoard: (x, y) ->
        x >= 0 and y >= 0 and x < @gridSize and y < @gridSize

    _validatePlayer: (player) ->
        if player < 0 or player > options.getOption 'players'
            throw "Invalid player: #{player}"

module.exports = State
