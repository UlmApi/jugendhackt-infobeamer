# jugendhackt-infobeamer

Scripts for using a frab-style schedule and infobeamer for Jugend hackt events. 

Ideally, it will provide an unattended installation and start from there.

## Getting started with autoinstallation

To get your own fahrplan and visualization, perform the following steps:

 # Download the current version of [raspberrypi-ua-netinst](https://github.com/FooDeas/raspberrypi-ua-netinst) and write it onto your SD card, e.g. `xzcat raspberrypi-ua-netinst-v2.0.0.img.xz | sudo dd bs=4M of=/dev/mmcblk0`
 # Copy the files in the [/raspberrypi-ua-netinst/config](raspberrypi-ua-netinst/config) folder into the `/raspberrypi-ua-netinst/config` folder in the freshly created SD card
 # Insert the SD card into your Pi, connect it to LAN and power and keep your fingers crossed – raspbian, info-beamer and the jugendhackt-infobeamer packages should be installed automatically and henceforth be started after booting.

## Updating the schedule

 * edit [jh-fahrplan/jugendhackt.ini](jh-fahrplan/jugendhackt.ini) and update the title, acronym and start/end dates for your event
 * edit [jh-fahrplan/jugendhackt.csv](jh-fahrplan/jugendhackt.csv) to reflect your plans. It might be easier to build a different csv for each day/a separate one for the lightning talks
 * export the csv fahrplan by copying the `fahrplan` folder into your [voctosched](https://github.com/zuntrax/voctosched) base directory and calling the ini file, e.g.: `python3.6 schedule.py -vvd -c fahrplan/jugendhackt.ini`
 * make the resulting schedule.xml accessible, e.g. by calling a simple http server from within the jh-fahrplan directory: `python3 -m http.server 8082`

## Acknowledgements

The unattended installation script and how the information is called after booting is heavily based on [webcampsi/info-beamer](https://github.com/webcampsi/info-beamer).

## TODO

 * `wget info-beamer-pi` instead of delivering it with this repo (which kind of taints the license)
 * Add and refine info-beamer visualization for info-beamer
 * Streamline the schedule export process
