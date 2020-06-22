# sink-switch
Small script to change playback device (sink) on systems using PulseAudio.

When for example you have speakers and headphones connected at the same time, this script can be used to switch between them.
It will change the default sink and move active input streams to the new sink.
Assign a keyboard shortcut to the script for easy usage.

### Disable stream target device restore
To be able to switch the default sinks from the command line, you may need to **disable stream target device restore**.
You can do this by editing the corresponding line in `/etc/pulse/default.pa` to:
```
load-module module-stream-restore restore_device=false
```
This only needs to be done once.