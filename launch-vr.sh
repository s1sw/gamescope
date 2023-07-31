#!/bin/bash
SCRIPT_PATH=$(dirname "$0")

# Parameters to change
width=1920
height=1080
physical_width=2
show_controls=1

print_usage_and_exit() {
    echo "Specify a program to run inside Gamescope with 2 dashes, for example:"
    echo "./launch-vr.sh -- glxgears"
    echo "You can also change some other parameters:"
    echo "-w, --width: Width of simulated screen in pixels"
    echo "-h, --height: Height of simulated screen in pixels"
    echo "-p, --physical-width: Physical width of simulated screen in metres"
    echo "-c, --hide-controls: Hide the control bar at the bottom of the overlay"
    exit 1
}

cd $SCRIPT_PATH

# Janky argument parsing
while [[ $# -gt 0 ]]; do
  case $1 in
    -w|--width)
      width="$2"
      shift
      shift
      ;;
    -h|--height)
      height="$2"
      shift
      shift
      ;;
    -p|--physical-width)
      physical_width="$2"
      shift
      shift
      ;;
    -c|--hide-controls)
      show_controls=0
      shift
      ;;
    --)
      shift
      break
      ;;
    -*|--*)
      echo "Unknown option $1"
      print_usage_and_exit
      ;;
    *)
      shift
      ;;
  esac
done

if [[ $# -eq 0 ]]; then
    print_usage_and_exit
fi

extra_args=""

if [[ $show_controls ]]; then
    extra_args="--vr-overlay-enable-control-bar --vr-overlay-enable-control-bar-keyboard --vr-overlay-enable-control-bar-close"
fi

# Gamescope command
./build/src/gamescope --openvr --vr-overlay-icon $(realpath frog.png) --vr-overlay-key gs --vr-overlay-physical-width $physical_width -W $width -H $height $extra_args -- $@
