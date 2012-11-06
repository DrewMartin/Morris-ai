
_ = require 'underscore'

options = require './options'

neighbours =
    0: [1, 9]
    1: [0, 2, 4]
    2: [1, 14]
    3: [4, 10]
    4: [1, 3, 5, 7]
    5: [4, 13]
    6: [7, 11]
    7: [4, 6, 8]
    8: [7, 12]
    9: [0, 10, 21]
    10: [3, 9, 11, 18]
    11: [6, 10, 15]
    12: [8, 13, 17]
    13: [5, 12, 14, 20]
    14: [2, 13, 23]
    15: [11, 16]
    16: [15, 17, 19]
    17: [12, 16]
    18: [10, 19]
    19: [16, 18, 20, 22]
    20: [13, 19]
    21: [9, 22]
    22: [19, 21, 23]
    23: [14, 22]

lines = [
    [0, 1, 2]
    [3, 4, 5]
    [6, 7, 8]
    [9, 10, 11]
    [12, 13, 14]
    [15, 16, 17]
    [18, 19, 20]
    [21, 22, 23]
    [0, 9, 21]
    [1, 4, 7]
    [2, 14, 23]
    [3, 10, 18]
    [5, 13, 20]
    [6, 11, 15]
    [8, 12, 17]
    [16, 19, 22]
]

boardStr = """
\  #------------#------------#
\  | \\          |          / |
\  |   #--------#--------#   |
\  |   | \\      |      / |   |
\  |   |   #----#----#   |   |
\  |   |   |         |   |   |
\  #---#---#         #---#---#
\  |   |   |         |   |   |
\  |   |   #----#----#   |   |
\  |   | /      |      \\ |   |
\  |   #--------#--------#   |
\  | /          |          \\ |
\  #------------#------------#
"""

if options.getOption 'twelve'
    neighbours[0].push 3
    neighbours[3].push 0
    neighbours[3].push 6
    neighbours[6].push 3

    neighbours[2].push 5
    neighbours[5].push 2
    neighbours[5].push 8
    neighbours[8].push 5

    neighbours[15].push 18
    neighbours[18].push 15
    neighbours[18].push 21
    neighbours[21].push 18

    neighbours[17].push 20
    neighbours[20].push 17
    neighbours[20].push 23
    neighbours[23].push 20

    lines = lines.concat [
        [0, 3, 6]
        [2, 5, 8]
        [15, 18, 21]
        [17, 20, 23]
    ]
else
    boardStr = boardStr.replace(/\\/g, " ").replace(/\//g, " ")

boardStr = boardStr.replace /#/g, "%s"

isNeighbour = (from, to) ->
    return _.contains neighbours[from], to

getLinesContainingPosition = (pos) ->
    _.filter lines, (line) ->
        _.contains line, pos

module.exports = {
    boardStr
    getLinesContainingPosition
    isNeighbour
    lines
    neighbours
}
