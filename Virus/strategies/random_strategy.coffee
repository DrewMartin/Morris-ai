
_ = require 'underscore'
Strategy = require '../../Common/strategy'

class RandomStrategy extends Strategy
    search: ->
        moves = @_listAvailableMoves()
        return false if !moves.length
        return moves[_.random(moves.length - 1)]

module.exports = RandomStrategy
