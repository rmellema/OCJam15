This is my project for OCJam. 

It constists of multiple parts which all depend on each other.

*   *KNN*: A small library for doing K-Nearest Neighbour. It also has
    functions for calculating the euclidian distance between two points.

*   *IBL*: Intelligent Block Locator, uses `knn` for locating blocks of 
    interest in a set area around a geolyzer. It returns all the relative
    coordinates of the found blocks.

*   *RPC*: A library that tries to shorten paths with absolute coordinates.

*   *LAMA*: Location Aware Movement API, a library for moving a robot 
    through the world using relative coordinates and the robots 
    orienatation.

    Also has functions for moving the robot an `x` amount of blocks, like
    `lama.forward(10)`.

*   *IBM*: Intelligent Block Miner, uses `ibl` to find blocks, `rpc` to 
    plan a shorter path through the locations and `lama` to move through
    the locations. Comes as both a library and a program.

Before `lama` or `ibm` can be used, `lama` has to be initialized. This 
can be done by setting the orientation in `lama` with the following
Lua code: `lama.setOrientation(sides.<direction robot is facing>)`. So
if the robot is facing south, the call becomes: `lama.setOrientation(sides.south)`.

