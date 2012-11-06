
_ = require 'underscore'
options = require './options'
phases = require './phases'
layout = require './layout'

POSITION_COUNT = 24

isEmpty = (thing) ->
    _.isUndefined(thing) or _.isNull(thing)

class State
    piecesToPlace: if options.getOption('twelve') then 24 else 18
    phase: phases.PLACEMENT_PHASE

    constructor: (clone) ->
        _.bindAll(@)

        @positions = new Array POSITION_COUNT unless clone

    clone: ->
        state = new State(true)
        state.positions = _.clone @positions
        state.phase = @phase
        state.piecesToPlace = @piecesToPlace

        return state

    countPiecesByPlayer: ->
        playerCount = [0, 0]
        _.each @positions, (pos) ->
            playerCount[pos]++ if !isEmpty pos
        return playerCount

    countPossibleMills: (position, player, fromPos) ->
        possible = _.filter layout.lines, (line) =>
            return false unless position in line
            for pos in line
                return false if !isEmpty(@positions[pos]) and @positions[pos] != player
            return true

        possible = _.map possible, (line) =>
            me = 1
            for pos in line
                me += 10 if @positions[pos] == player and pos != fromPos

            return me

        count = (_.reduce possible, ((memo, num) -> memo + num), 0) or 0

        return count

    doMove: (move, player) ->
        if @phase == phases.PLACEMENT_PHASE
            @_doPlacementMove move, player
            @piecesToPlace--
            if !@piecesToPlace
                @phase = phases.SHIFT_PHASE
        else
            @_doShiftMove move, player

    enumMovesForPlayer: (player) ->
        if @phase == phases.PLACEMENT_PHASE
            return @_enumPlacementMoves player
        else
            return @_enumShiftMoves player

    getCurrentPhase: -> @phase

    map: (cb) ->
        (cb pos for pos in @positions)

    _doRemoveStep: (move) ->
        if move.remove
            for remove in move.remove
                delete @positions[remove]

    _doPlacementMove: (move, player) ->
        if !@_isValidPlacementMove move, player
            throw "Placement move #{JSON.stringify move} for player #{player+1} is invalid"

        @positions[move.to] = player
        @_doRemoveStep move

    _doShiftMove: (move, player) ->
        if !@_isValidShiftMove move, player
            throw "Shift move #{JSON.stringify move} for player #{player+1} is invalid"

        @positions[move.to] = player
        delete @positions[move.from]
        @_doRemoveStep move

    _createRemoveMoves: (moves, player) ->
        enemyNum = (player + 1) % 2
        enemyPos = (i for i, pos of @positions when pos == enemyNum)

        _.each moves, (move) =>
            millCount = @_millCountForMoveForPlayer move, player
            if millCount
                move.remove = enemyPos[0...millCount]
        return moves

    _enumPlacementMoves: (player) ->
        moves = (i for i in [0...POSITION_COUNT] when isEmpty @positions[i])
        moves = _.map moves, (move) =>
            move = to: move
        return @_createRemoveMoves moves, player

    _enumShiftMoves: (player) ->
        positionEnum = [0...POSITION_COUNT]
        playerPositions = (i for i in positionEnum when @positions[i] == player)

        moves = _.flatten _.map playerPositions, (pos) =>
            toMoves = (n for n in layout.neighbours[pos] when isEmpty @positions[n])
            return _.map toMoves, (toPos) ->
                return from: pos, to: toPos
        return @_createRemoveMoves moves, player

    _isPositionOnBoard: (position) ->
        return !isEmpty(position) and position >= 0 and position < POSITION_COUNT

    _millCountForMoveForPlayer: (move, player) ->
        lines = layout.getLinesContainingPosition move.to
        lines = _.filter lines, (line) =>
            allVal = _.all line, (linePos) =>
                return false if linePos == move.from
                return linePos == move.to or @positions[linePos] == player
            return allVal
        return lines.length

    _validateMoveCommon: (move, player) ->
        return false if isEmpty move.to
        return false if !isEmpty @positions[move.to]
        return false if !@_isPositionOnBoard move.to
        if move.remove
            millCount = @_millCountForMoveForPlayer move, player
            if millCount != move.remove.length
                console.log "Mill count was", millCount, "While only", move.remove.length, "were done"
            if move.remove.length > millCount
                return false
            for remove in move.remove
                return false if !@_isPositionOnBoard remove
                return false if @positions[remove] == player
                return false if isEmpty @positions[remove]
        return true


    _isValidShiftMove: (move, player) ->
        return false if !@_validateMoveCommon move, player
        return false if isEmpty move.from
        return false if !@_isPositionOnBoard move.from
        return false if @positions[move.from] != player
        return false if !layout.isNeighbour move.from, move.to
        return true

    _isValidPlacementMove: (move, player) ->
        return false if !@_validateMoveCommon move, player
        return true


module.exports = State
