
_ = require 'underscore'

options  = require '../options'
MiniMax  = require '../../Common/minimax_strategy'
phases   = require '../phases'

first = true

class Smart extends MiniMax

    generateChildrenStates: (state, player, flag) ->
        moves = state.enumMovesForPlayer player
        moves = _.shuffle moves

        if state.getCurrentPhase() == phases.PLACEMENT_PHASE
            moves = _.sortBy moves, (move) ->
                -state.countPossibleMills move.to, player

        children = _.map moves, (move) =>
            child = {move}
            newState = state.clone()

            if move == false
                if player == @player
                    child.lose = true
                else
                    child.win = true
                return

            newState.doMove move, player
            heur = @heuristic newState

            if heur == true
                child.win = true
            else if heur == false
                child.lose = true
            else
                child.score = heur

            child.state = newState

            return child

        return children

module.exports = Smart
