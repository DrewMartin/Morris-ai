
_ = require 'underscore'

options  = require '../options'
Strategy = require '../../Common/strategy'

class MaxNStrategy extends Strategy

    search: ->
        result = @max_n  @initialState, @depth, 0
        return result.move

    generateChildrenStates: (state, player) ->
        moves = state.enumMovesForPlayer player
        moves = _.filter moves, (move) ->
            state.isMoveUseful move.x, move.y, player
        children = _.map moves, (move) =>
            child = {move}
            newState = state.clone()
            newState.capture move.x, move.y, player
            heur = @heuristic newState, player
            child.score = heur

            child.state = newState

            return child

        return children


    heuristic: (state, player) ->
        return state.numSpacesControlledByPlayers()

    max_n: (state, depth, playerIndex) ->
        player = @playerList[playerIndex]
        if depth == 0
            return score: @heuristic(state)

        children = @generateChildrenStates state, @playerList[playerIndex]
        return score: @heuristic(state) if !children.length

        val = -999999999
        bestMove = children[0].move
        tuple = []
        nextPlayerIndex = @_nextPlayerIndex playerIndex
        for child in children
            res = @max_n(child.state, depth-1, nextPlayerIndex)
            if res.score[player] > val
                val = res.score[player]
                tuple = res.score
                bestMove = child.move
        console.log "d#{depth} Best move", bestMove, "first:", children[0].move if depth == 4

        return score: tuple, move: bestMove

    _nextPlayerIndex: (playerIndex) ->
        playerIndex = (playerIndex + 1) % @playerList.length

module.exports = MaxNStrategy
