
# Timelapse Aseprite extension

An Aseprite extension that helps you produce a timelapse of your art by automatically taking snapshots as you work on your art.

## Installation

Just zip this folder, name the resulting file `timelapse.aseprite-extension` and double-click it to add it to aseprite.

## Using it

This extension will create a folder named `<filename>-timelapse` and then save a sequence of files named `0.png`, `1.png`, and so on, for every change in your sprite. Even changes like undo/redo will be registered.

The extension will only start the sequence after your sprite is saved for the first time, since it needs to know where the file lives to know where to create the timelapse folder.

Once you finish working on your art, you will need some way of turning the file sequence into an animated gif. For that, one option is to use [timelapse-toolkit](https://github.com/luciopaiva/timelapse-toolkit).

## How it works

It relies on a relatively new [events feature](https://github.com/aseprite/api/blob/main/api/sprite.md#spriteevents), which lets scripts and extensions know there was a change in a sprite.

This was initially a script, but aseprite does not guarantee your script will have a single instance. The user is able to spawn multiple instances of your script. This is bad because it will register multiple event listeners, triggering the file save multiple times. The solution to that was to make it into an extension, when aseprite does guarantee a single instance.
