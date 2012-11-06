fs = require 'fs'
_ = require 'underscore'

strategies = {}

dir = fs.readdirSync(__dirname)

_.each dir, (file) ->
    match = file.match /^(\w+)_strategy\.coffee$/
    if match
        strategies[match[1]] = require "./#{file}"

module.exports = strategies
