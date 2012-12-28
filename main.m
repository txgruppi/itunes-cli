// Native iTunes Command line Interface
// A simple cli to control itunes, based on iTunes Command Line Control v1.0 written by David Schlosnagle
//
// @author Tarcísio Gruppi <txgruppi@gmail.com>
// @date 2012-12-28

#include <stdlib.h>
#include <stdio.h>
#include <string.h>
#include "iTunes.h"

// Run iTunes if its not running
//
// @param *itunes The iTunesApplication instance
void runIfNotRunning(iTunesApplication *itunes) {
  if (![itunes isRunning]) {
    [itunes run];
  }
}

// Quit iTunes if its running
//
// @param *itunes iTunesApplication instance
void quitIfRunning(iTunesApplication *itunes) {
  if ([itunes isRunning]) {
    [itunes quit];
  }
}

// Get iTunes current playState
//
// States:
//   stopped
//   playing
//   paused
//   fast forwarding
//   rewinding
//   closed
//
// @param *itunes iTunesApplication instance
//
// @return state string
char *getState(iTunesApplication *itunes) {
  char *state;

  if ([itunes isRunning]) {
    switch (itunes.playerState) {
      case iTunesEPlSStopped:
      state = "stopped";
      break;
      case iTunesEPlSPlaying:
      state = "playing";
      break;
      case iTunesEPlSPaused:
      state = "paused";
      break;
      case iTunesEPlSFastForwarding:
      state = "fast forwarding";
      break;
      case iTunesEPlSRewinding:
      state = "rewinding";
      break;
    }
  } else {
    state = "closed";
  }

  return state;
}

// Print usage message
//
// @param *cmd the command used to run this app Ex.: argv[0]
void usage(char *cmd) {
  printf("Usage: %s <command>\n\n  Commands:\n", cmd);
  printf("    %-28s\n      %s\n", "status",                     "Show iTunes status and track information");
  printf("    %-28s\n      %s\n", "play|pause|playpause",       "Toggle the playing/paused state of the current track");
  printf("    %-28s\n      %s\n", "next",                       "Advance to the next track in the current playlist");
  printf("    %-28s\n      %s\n", "prev",                       "Return to the previous track in the current playlist");
  printf("    %-28s\n      %s\n", "back",                       "Reposition to beginning of current track or go to previous track if already at start of current track");
  printf("    %-28s\n      %s\n", "stop",                       "Stop playback");
  printf("    %-28s\n      %s\n", "resume",                     "Disable fast forward/rewind and resume playback, if playing");
  printf("    %-28s\n      %s\n", "fastForward|fastforward|ff", "Skip forward in a playing track");
  printf("    %-28s\n      %s\n", "rewind|rw",                  "Skip backwards in a playing track");
  printf("    %-28s\n      %s\n", "mute",                       "Mute iTunes' volume");
  printf("    %-28s\n      %s\n", "unmute",                     "Unmute iTunes' volume");
  printf("    %-28s\n      %s\n", "vol up",                     "Increase iTunes' volume by 10%");
  printf("    %-28s\n      %s\n", "vol down",                   "Decrease iTunes' volume by 10%");
  printf("    %-28s\n      %s\n", "vol #",                      "Set iTunes' volume to # [0-100]");
  printf("    %-28s\n      %s\n", "quit",                       "Quit iTunes");
}

int main(int argc, char **argv) {
  iTunesApplication *itunes = [SBApplication applicationWithBundleIdentifier:@"com.apple.iTunes"];
  int cmdFound = 0;

  if (argc == 2) {
    if (strcmp(argv[1], "play") == 0 || strcmp(argv[1], "pause") == 0 || strcmp(argv[1], "playpause") == 0) {
      runIfNotRunning(itunes);
      [itunes playpause];
      cmdFound = 1;
    } else if (strcmp(argv[1], "next") == 0) {
      runIfNotRunning(itunes);
      [itunes nextTrack];
      cmdFound = 1;
    } else if (strcmp(argv[1], "prev") == 0) {
      runIfNotRunning(itunes);
      [itunes previousTrack];
      cmdFound = 1;
    } else if (strcmp(argv[1], "back") == 0) {
      runIfNotRunning(itunes);
      [itunes backTrack];
      cmdFound = 1;
    } else if (strcmp(argv[1], "stop") == 0) {
      runIfNotRunning(itunes);
      [itunes stop];
      cmdFound = 1;
    } else if (strcmp(argv[1], "resume") == 0) {
      runIfNotRunning(itunes);
      [itunes resume];
      cmdFound = 1;
    } else if (strcmp(argv[1], "fastForward") == 0 || strcmp(argv[1], "fastforward") == 0 || strcmp(argv[1], "ff") == 0) {
      runIfNotRunning(itunes);
      [itunes fastForward];
      cmdFound = 1;
    } else if (strcmp(argv[1], "rewind") == 0 || strcmp(argv[1], "rw") == 0) {
      runIfNotRunning(itunes);
      [itunes rewind];
      cmdFound = 1;
    } else if (strcmp(argv[1], "quit") == 0) {
      quitIfRunning(itunes);
      cmdFound = 1;
    } else if (strcmp(argv[1], "mute") == 0) {
      runIfNotRunning(itunes);
      itunes.mute = true;
      cmdFound = 1;
    } else if (strcmp(argv[1], "unmute") == 0) {
      runIfNotRunning(itunes);
      itunes.mute = false;
      cmdFound = 1;
    } else if (strcmp(argv[1], "status") == 0) {
      printf("iTunes is %s\n", getState(itunes));
      if ([itunes isRunning]) {
        iTunesTrack *track = itunes.currentTrack;
        printf("Current track %s: %s [%ld of %d seconds]\n", [track.artist UTF8String], [track.name UTF8String], itunes.playerPosition, (int) track.duration);
      }
      cmdFound = 1;
    }
  } else if (argc == 3) {
    if (strcmp(argv[1], "vol") == 0) {
      if (strcmp(argv[2], "up") == 0) {
        runIfNotRunning(itunes);
        if (itunes.soundVolume < 100)
          itunes.soundVolume += 10;
        cmdFound = 1;
      } else if (strcmp(argv[2], "down") == 0) {
        runIfNotRunning(itunes);
        if (itunes.soundVolume > 0)
          itunes.soundVolume -= 10;
        cmdFound = 1;
      } else {
        int vol = atoi(argv[2]);
        itunes.soundVolume = vol;
        cmdFound = 1;
      }
    }
  }

  if (!cmdFound) {
    usage(argv[0]);
    return 1;
  }

  return 0;
}