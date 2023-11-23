# Nixos-Decklink-Ffmpeg

Minimal example of ffmpeg + decklink usage on NixOS

## Setup
* Setup fresh NixOS on your machine
* Create new folder `./machines/<selected-host-name>`
* Copy `hardware-configuration.nix` from `/etc/nixos/` to `./machines/<selected-host-name>`
* Change parts to match `./machines/decklink-machine/hardware-configuration.nix`
* Copy `./machines/decklink-machine/configuration.nix` to `./machines/<selected-host-name>/configuration.nix`
* Change hostname to match new machine in `./machines/<selected-host-name>/configuration.nix`

* Copy these files to `/etc/nixos` and run `sudo nixos-rebuild switch`

## Useful ffmpeg commands

* List decklink devices `ffmpeg -sources decklink`
* List device available formats `ffmpeg -f decklink -list_formats 1 -i "<name of device>"`
* Record sample from card
```
ffmpeg -f decklink -i "DeckLink Mini Recorder 4K" -format_code "Hp59" -video_size 1920x1080 -rtbufsize 2100M -c:v libx264 -preset:v ultrafast -pix_fmt yuv422p -an -crf 18 output.mp4
```
