
# Timelapse

An Aseprite script that records a timelapse of your art, producing an animation as a result.

The idea is that regular snapshots are taken as you work on your art. Ideally, the snapshots would be taken automatically, but for that we would need a timer mechanism of some sort. Aseprite API doesn't provide something like that and there is no known way of emulating a periodic task that doesn't block the UI as it waits between snapshots. Even better, if Aseprite provided events like "pixel changed", we could respond to those changes to know when to take a new snapshot, but that mechanism doesn't exist either.

My solution to this problem is to rely on a timer external to the application. For it to act on Aseprite, my solution involves defining a hot key for my script on Aseprite, and then creating an external application that fires a timer event regularly, which sends the necessary hot key to Aseprite to trigger the script.

Every time the script is triggered, it takes a snapshot of the current state of the sprite being worked on. The snapshot is saved to a file with the same name as the sprite file, but appeneded with the current date and time.

To avoid the creation of unnecessary files when the sprite has not changed since the last snapshot, the script will take the snapshot, calculate a hash of the file and compare it against the previous one. If the hash matches, the new snapshot is erased.

Once the work is complete, a second script is responsible for merging all saved files to an animation.

## Associate a shortcut with the script

To associate a shortcut so it's easier to open the script, go to Edit -> Keyboard shortcuts and then find your script in the Menu -> Scripts section.
