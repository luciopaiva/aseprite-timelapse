
# Timelapse

An Aseprite script that helps you produce a timelapse of your art by letting you quickly take snapshots of your work.

Ideally, the snapshots would be taken automatically, but for that we would need a timer mechanism of some sort. Aseprite API doesn't provide something like that and there is no known way of emulating a periodic task that doesn't block the UI as it waits between snapshots. Even better, if Aseprite provided events like "pixel changed", we could respond to those changes to know when to take a new snapshot, but that mechanism doesn't exist either.

My solution to this problem is to rely on a timer external to the application. For it to act on Aseprite, my solution involves defining a hot key for my script on Aseprite, and then [using an external application](https://github.com/luciopaiva/hotkey-repeat) that fires a timer event regularly, which sends the necessary hot key to Aseprite to trigger the script.

Every time the script is triggered, it takes a snapshot of the current state of the sprite being worked on. The snapshot is saved to a file with the same name as the sprite file, but appended with the current date and time.

Once your work is complete, you can use [timelapse-toolkit](https://github.com/luciopaiva/timelapse-toolkit) to generate a GIF animation.

## Associate a shortcut with the script

To associate a shortcut, so it's easier to open the script, go to Edit -> Keyboard shortcuts and then find your script in the Menu -> Scripts section.

## Can the script save in .aseprite format?

No. Even if you use Aseprite itself to generate the GIF, it only accepts PNGs when creating an animation from a sequence.
