Virus and Nine Men's Morris

The virus game is simple: Each player takes a turn infecting a square that is either their own, or touches one of their squares. Doing so captures the square they infect, and the squares directly adjacent to the infected square in a cross pattern. Once only one player is left, the game is over and they win. Player one (red) uses an intelligent strategy based on the number of players, and the other players pick random moves on their turn. The red player should always win. With two players, the red player uses an [alpha-beta pruning strategy](http://en.wikipedia.org/wiki/Alpha-beta_pruning). With 3+ players, it uses a MaxN strategy.

Rules of nine men's morris can be found [here](http://en.wikipedia.org/wiki/Nine_Men's_Morris). Both players use an intelligent, alpha-beta pruning strategy here. For the red player, the heuristic at each step is the number of their pieces minus the opponent's pieces. The blue player's heuristic is the number of their pieces divided by the opponent's pieces.

Installation:
* Download and install node.js from http://nodejs.org/
* Type `npm install --global coffee-script`
* In the root of the project directoy, type npm install
* Use `coffee main.coffee` in either the Morris or Virus directories to run the appropriate game.

Parameters are available at the command line with `coffee main.coffee --help`