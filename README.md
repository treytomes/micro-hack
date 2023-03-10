# µ-hack
Traditional roguelike written for the Mini Micro.

Use the arrow keys to walk around.

Actions are defined in "actions.ms".  Ultimately each action will have an Action Point cost associated with it that will be affected by the entity's speed.
Behaviors are a collection of semi-intelligent chunks that can be run together as a list.  Behaviors affect entity state and can generate actions.

# Ideas
The random walking algorithm works fine.  Attach it to a slime monster that will wander around and split from time to time.  Splitting cuts the health in half.  Slime will slowly heal itself.

# References
* [MiniScript](https://miniscript.org/)
* [MiniScript Manual](https://miniscript.org/files/MiniScript-Manual.pdf)
* [Mini Micro](https://miniscript.org/wiki/Mini_Micro)
* [Roguelike Tutorial](https://rogueliketutorials.com/tutorials/tcod/v2/)

