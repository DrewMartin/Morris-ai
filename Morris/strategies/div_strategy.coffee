
_ = require 'underscore'

options  = require '../options'
phases   = require '../phases'
Smart    = require './smart'

class DivStrategy extends Smart

    heuristic: (state, player) ->
        playerCount = state.countPiecesByPlayer()
        me = @player
        enemy = (@player + 1) % 2
        if state.getCurrentPhase() == phases.SHIFT_PHASE
            if playerCount[me] == 0
                return false
            if playerCount[enemy] == 0
                return true
        return 999999 if playerCount[enemy] == 0
        return playerCount[me] / playerCount[enemy]

module.exports = DivStrategy
