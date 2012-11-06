
_ = require 'underscore'

class Strategy

    constructor: (@initialState, @player, @playerList, @depth) ->

    search: ->
        throw "Strategy.search should be implemented for all subclasses"

    _listAvailableMoves: ->
        @initialState.enumMovesForPlayer @player

module.exports = Strategy
