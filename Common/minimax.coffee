
_ = require 'underscore'

class MiniMax

    constructor: (@initialState, @maxDepth, @playerList, @strategy) ->
        _.bindAll(@)

    search: ->
        result = @_maxSearch @initialState, @maxDepth, -999999999, 999999999, 0
        return result.move

    _maxSearch: (state, depth, α, β, playerIndex) ->
        if depth == 0
            return score: @_evalheuristic @strategy.heuristic state, @playerList[playerIndex]

        children = @strategy.generateChildrenStates state, @playerList[playerIndex]
        return score: @_evalheuristic @strategy.heuristic state, @playerList[playerIndex] if !children.length

        children = _.sortBy children, (child) =>
            -@_evalstate child

        bestMove = children[0].move
        for child in children
            if child.lose
                continue
            else if child.win
                bestMove = child.move
                α = 999999999
                break
            else
                evaled = @_minSearch child.state, depth-1, α, β, @_nextPlayerIndex playerIndex
                if evaled.score > α
                    α = evaled.score
                    bestMove = child.move
                if β <= α
                    break

        return score: α, move: bestMove

    _minSearch:  (state, depth, α, β, playerIndex) ->
        if depth == 0
            return score: @_evalheuristic @strategy.heuristic state, @playerList[playerIndex]

        children = @strategy.generateChildrenStates state, @playerList[playerIndex]
        return score: @_evalheuristic @strategy.heuristic state, @playerList[playerIndex] if !children.length

        children = _.sortBy children, (child) =>
             @_evalstate child

        nextPlayerIndex = @_nextPlayerIndex playerIndex
        nextSearch = if nextPlayerIndex then @_minSearch else @_maxSearch

        for child in children
            if child.lose
                β = -999999999
                break
            else if child.win
                continue
            else
                evaled = nextSearch child.state, depth-1, α, β, nextPlayerIndex
                β = _.min [β, evaled.score]
                if β <= α
                    break

        return score: β

    _evalheuristic: (e) ->
        return 999999999 if e == true
        return -999999999 if e == false
        return e

    _evalstate: (s) ->
        return 999999999 if s.win == true
        return -999999999 if s.lose == true
        return s.score

    _nextPlayerIndex: (playerIndex) ->
        playerIndex = (playerIndex + 1) % @playerList.length


module.exports = MiniMax