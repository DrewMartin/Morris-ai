
_ = require 'underscore'

Strategy = require './strategy'
MiniMax  = require './minimax'

class MinimaxStrategy extends Strategy

    search: ->
        strat = new MiniMax @initialState, @depth, @playerList, @
        strat.search()

    generateChildrenStates: (state, player) ->
        throw "Strategy.generateChildrenStates should be implemented for all subclasses"


    heuristic: (state, player) ->
        throw "Strategy.heuristic should be implemented for all subclasses"

module.exports = MinimaxStrategy
