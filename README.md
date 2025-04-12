# legends - bash game

For one of my university classes I had to write a script in bash...

So I wrote a game.

![showcase1](./showcase/showcase1.png)

## Steps to run
	$ make
	$ ./legends.sh

## Description

You're a mage that is attacked by a hordes of orcs. The only thing you have is your trusty fire staff. How long will you survive?

![showcase2](./showcase/showcase2.png)

## Technical details

All game logic is written in bash (keyboard input, collision detection, spawning / death of enemies, moving to a different biome, kills counter).
For graphics I use a linux framebuffer.
And because of performance reasons writes to framebuffer can't be done in bash, so the script generates a file with positions and states of all objects in the world and then sends a signal to C program that opens that file and does the updates to framebuffer.
Music is played by launching mplayer in background.

## Attribution

All images and music are from the Battle for Wesnoth https://www.wesnoth.org/
