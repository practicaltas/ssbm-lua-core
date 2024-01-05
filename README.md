# ssbm-lua-core

Core functions for SSBM NTSC 1.02 and PAL using Lua Dolphin (https://github.com/SwareJonge/Dolphin-Lua-Core)

## Usage

Paste the core files into the root of your Dolphin install directory (i.e. at the same level as the `Sys` folder).

In your `.lua` file in `Sys/Scripts`, write (depending on your game version):

`local core = require "SSBM_PAL_core"` 

or

`local core = require "SSBM_NTSC_core"`

then use the core functions with `core.getRngSeed()` etc.

If you want to add new functions, you need to make sure to include the line

`core.functionName = functionName`

after the function definition in the core file.

## Note

The PAL core includes an automatic character selecting function that I never bothered to port to NTSC. This also requires pasting `Sys/SSBM_PAL_character_select_core.lua` and is executed via the script `SSBM_PAL_character_select.lua`. It reads the first line of `Sys/Scripts/character_select.txt`, selects that character, and saves the current state over savestate 2. The other lines in the .txt are present for easy pasting of the correctly written character names.

You can also use this file to see how a core function is used in other files.