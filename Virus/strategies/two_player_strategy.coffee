
_ = require 'underscore'

options  = require '../options'
MiniMax  = require '../../Common/minimax_strategy'

class TwoPlayerStrategy extends MiniMax

    constructor: (args...) ->
        super args...
        _.bindAll(@)

    generateChildrenStates: (state, player) ->
        moves = state.enumMovesForPlayer player
        moves = _.filter moves, (move) ->
            state.isMoveUseful move.x, move.y, player
        children = _.map moves, (move) =>
            child = {move}
            newState = state.clone()
            newState.capture move.x, move.y, player
            heur = @heuristic newState, player
            if heur is true
                child.win = true
            else if heur is false
                child.lose = true
            else
                child.score = heur
            child.state = newState

            return child

        return children


    heuristic: (state, player) ->
        spaces = state.numSpacesControlledByPlayers()
        stratPlayer = spaces[@player]
        mine = 0
        enemies = 0
        _.each spaces, (space, index) =>
            if index == player
                mine += space
            if index != @player
                enemies += space

        if enemies == 0
            return true
        else if mine == 0
            return false
        else
            return stratPlayer / (enemies*enemies)

module.exports = TwoPlayerStrategy
