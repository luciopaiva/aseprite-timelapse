
# Timelapse Aseprite extension

An Aseprite extension that helps you produce a *high-fidelity* timelapse of your art by automatically taking snapshots as you work on your art. Every change in the canvas is individually recorded.

## Installation

Download the most up-to-date version of `timelapse.aseprite-extension` [here](https://github.com/luciopaiva/aseprite-timelapse/releases), then double-click it to add it to aseprite.

Alternatively, download this repo, just its root folder, rename the zip file to `timelapse.aseprite-extension` and double-click it.

## Using it

This extension will create a folder named `<filename>-timelapse` in the same folder where your art was saved, and then generate a sequence of files named `0.png`, `1.png`, and so on, for every change in your sprite. Even changes like undo/redo will be registered.

The extension will only start the recording after your sprite is saved for the first time, since it needs to know where the file lives to know where to create the timelapse folder.

Once you finish working on your art, you will need some way of turning the file sequence into an animated gif. For that, one option is to use [timelapse-toolkit](https://github.com/luciopaiva/timelapse-toolkit).

## How it works

It relies on a relatively new [events feature](https://github.com/aseprite/api/blob/main/api/sprite.md#spriteevents), which lets scripts and extensions know there was a change in a sprite.

This was initially a script, but aseprite does not guarantee your script will have a single instance. The user is able to spawn multiple instances of your script. This is bad because it will register multiple event listeners, triggering the file save multiple times. The solution to that was to make it into an extension, when aseprite does guarantee a single instance.

## Advanced stuff

### Getting rid of the annoying "saving file" dialog

Every time a file is saved in aseprite, a modal dialog entitled "Saving file" is display for a very quick moment. It's so quick it's impossible to take a screenshot to show here, but it can be easily seen blink on the screen. Since it appears in the middle of the window, it fatally pops up in front of your art. Since timelapse constantly saves a copy of the file, it quickly escalates to become very annoying.

Although there is no way to circumvent it via the Lua API, it is possible to change the sources to remove it. In case you'd like to try, here's what you should do:

1. compile aseprite from its sources. This is the most difficult part, but it can be easier than you think. I wrote a quick tutorial for Windows [here](https://gist.github.com/luciopaiva/6a1f870f932a5f54011cc869c4d558a8);
2. find the file `src/app/commands/cmd_save_file.cpp`. It should be a class named `SaveFileJob` that extends from `Job`. It's in `SaveFileJob` that you will find the string "Saving file";
3. now follow the `Job` class and open it. It should be in `src/app/job.cpp`. Look for the method `Job::startJob()`. This is the line that opens the dialog:

       m_alert_window->openWindowInForeground();
   But do not just comment it out as it won't work properly;
4. instead, find the `Job`'s constructor method; that's where the alert is created. You should see something like this:

       if (App::instance()->isGui()) {
           m_alert_window = ui::Alert::create(
           fmt::format(Strings::alerts_job_working(), jobName));
           m_alert_window->addProgress();
    
           m_timer.reset(new ui::Timer(kMonitoringPeriod, m_alert_window.get()));
           m_timer->Tick.connect(&Job::onMonitoringTick, this);
           m_timer->start();
       }
   Here, this whole block should be commented out. It prevents not only the creation of the alert, but also of a timer that ticks to update the dialog as the save operation progresses.
5. recompile the code and run it to verify that the dialog is now gone.

I have doubts about the need of having this dialog at all. While it does allow you to cancel the operation, I don't see how that's helpful in any way, since probably the vast majority of the interactions will be so fast you won't even be able to click it. To communicate to the user that a save is in progress, maybe aseprite could just use the status bar at the bottom. I get it that `Job` blocks the main thread while `m_thread` works to save the file, but it's so quick it that it doesn't help to have a dialog popping up.
