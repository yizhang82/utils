#!/bin/bash

## Description
# Lenovo Carbon X1 Gen 7 - Audio and microphone fix - kernel 5.3+ required.
# The script has only been tested for Arch and OpenSuse,
# Original thread: https://forums.lenovo.com/t5/Ubuntu/Guide-X1-Carbon-7th-Generation-Ubuntu-compatability/td-p/4489823

# Prereq: Install Linux 5.3 or newer

# NOTE: run this script as root and at your own risk.

firmware_version=v1.4.1

echo Copy https://github.com/thesofproject/sof/releases/download/${firmware_version}/sof-cnl-${firmware_version}.ri to /lib/firmware/intel/sof/ as sof-cnl.ri
mkdir -p /lib/firmware/intel/sof/
curl -L https://github.com/thesofproject/sof/releases/download/${firmware_version}/sof-cnl-${firmware_version}.ri -o /lib/firmware/intel/sof/sof-cnl.ri

echo Copy https://github.hamidzare.xyz/dl/sof-hda-generic.tplg to /lib/firmware/intel/sof-tplg/ as sof-hda-generic-4ch.tplg
mkdir -p /lib/firmware/intel/sof-tplg/
curl -L https://github.hamidzare.xyz/dl/sof-hda-generic.tplg -o /lib/firmware/intel/sof-tplg/sof-hda-generic-4ch.tplg
ln -s /lib/firmware/intel/sof-tplg/sof-hda-generic-4ch.tplg /lib/firmware/intel/sof-tplg/sof-hda-generic.tplg

echo creating file /etc/modprobe.d/alsa-base.conf  ------

cat <<EOT >> /etc/modprobe.d/alsa-base.conf
# autoloader aliases
install sound-slot-0 /sbin/modprobe snd-card-0
install sound-slot-1 /sbin/modprobe snd-card-1
install sound-slot-2 /sbin/modprobe snd-card-2
install sound-slot-3 /sbin/modprobe snd-card-3
install sound-slot-4 /sbin/modprobe snd-card-4
install sound-slot-5 /sbin/modprobe snd-card-5
install sound-slot-6 /sbin/modprobe snd-card-6
install sound-slot-7 /sbin/modprobe snd-card-7

# Cause optional modules to be loaded above generic modules
install snd /sbin/modprobe --ignore-install snd $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-ioctl32 ; /sbin/modprobe --quiet --use-blacklist snd-seq ; }
#
# Workaround at bug #499695 (reverted in Ubuntu see LP #319505)
install snd-pcm /sbin/modprobe --ignore-install snd-pcm $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-pcm-oss ; : ; }
install snd-mixer /sbin/modprobe --ignore-install snd-mixer $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-mixer-oss ; : ; }
install snd-seq /sbin/modprobe --ignore-install snd-seq $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-seq-midi ; /sbin/modprobe --quiet --use-blacklist snd-seq-oss ; : ; }
#
install snd-rawmidi /sbin/modprobe --ignore-install snd-rawmidi $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-seq-midi ; : ; }
# Cause optional modules to be loaded above sound card driver modules
install snd-emu10k1 /sbin/modprobe --ignore-install snd-emu10k1 $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-emu10k1-synth ; }
install snd-via82xx /sbin/modprobe --ignore-install snd-via82xx $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist snd-seq ; }

# Load saa7134-alsa instead of saa7134 (which gets dragged in by it anyway)
install saa7134 /sbin/modprobe --ignore-install saa7134 $CMDLINE_OPTS && { /sbin/modprobe --quiet --use-blacklist saa7134-alsa ; : ; }
# Prevent abnormal drivers from grabbing index 0
options bt87x index=-2
options cx88_alsa index=-2
options saa7134-alsa index=-2
options snd-atiixp-modem index=-2
options snd-intel8x0m index=-2
options snd-via82xx-modem index=-2
options snd-usb-audio index=-2
options snd-usb-caiaq index=-2
options snd-usb-ua101 index=-2
options snd-usb-us122l index=-2
options snd-usb-usx2y index=-2
# Ubuntu #62691, enable MPU for snd-cmipci
options snd-cmipci mpu_port=0x330 fm_port=0x388
# Keep snd-pcsp from being loaded as first soundcard
options snd-pcsp index=-2
# Keep snd-usb-audio from being loaded as first soundcard
options snd-usb-audio index=-2
EOT
 
echo finished creating  /etc/modprobe.d/alsa_base.conf  ------


echo creating file /etc/modprobe.d/blacklist.conf  -------
cat <<EOT >> /etc/modprobe.d/blacklist.conf
blacklist snd_hda_intel
blacklist snd_soc_skl
EOT
echo finished creating  /etc/modprobe.d/blacklist.conf  -------

echo creating file /usr/share/alsa/ucm/sof-skl_hda_card/HiFi.conf -------
mkdir -p /usr/share/alsa/ucm/sof-skl_hda_card
cat <<EOT >> /usr/share/alsa/ucm/sof-skl_hda_card/HiFi.conf
# Use case Configuration for skl-hda-card

SectionVerb {

 EnableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Master Playback Switch' on"
  cset "name='Capture Switch' on"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
 ]
}

SectionDevice."Headphone" {
 Comment "Headphone"

 EnableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Headphone Playback Switch' on"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Headphone Playback Switch' off"
 ]

 Value {
  PlaybackPCM "hw:sofsklhdacard,0"
  PlaybackChannels "2"
  JackName "sof-skl_hda_card Headphone"
  JackType "gpio"
  JackSwitch "12"
  JackControl "Headphone Jack"
 }
}

SectionDevice."Speaker" {
 Comment "Speaker"

 EnableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Speaker Playback Switch' on"
 ]

 DisableSequence [
  cset "name='Speaker Playback Switch' off"
 ]

 Value {
  PlaybackPCM "hw:sofsklhdacard,0"
  JackHWMute "Headphone"
  PlaybackChannels "2"
 }
}

SectionDevice."Headset" {
 Comment "Headset Mic"

 ConflictingDevice [
  "DMIC Stereo"
 ]

 EnableSequence [
  cdev "hw:sofsklhdacard"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
 ]

 Value {
  CapturePCM "hw:0,0"
  CaptureChannels "2"
  JackControl "Mic Jack"
 }
}

SectionDevice."Dmic" {
 Comment "DMIC Stereo"

 ConflictingDevice [
  "Headset Mic"
 ]

 EnableSequence [
  cdev "hw:sofsklhdacard"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
 ]

 Value {
  CapturePCM "hw:0,6"
  CaptureChannels "2"
 }
}

SectionDevice."HDMI1" {
 Comment "HDMI1/DP1 Output"

 EnableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='hif5-0 Jack Switch' on"
  cset "name='Pin5-Port0 Mux' 1"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Pin5-Port0 Mux' 0"
  cset "name='hif5-0 Jack Switch' off"
 ]

 Value {
  PlaybackPCM "hw:0,3"
  PlaybackChannels "2"
  JackControl "HDMI/DP, pcm=11 Jack"
 }
}

SectionDevice."HDMI2" {
 Comment "HDMI2/DP2 Output"

 EnableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='hif6-0 Jack Switch' on"
  cset "name='Pin6-Port0 Mux' 2"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Pin6-Port0 Mux' 0"
  cset "name='hif6-0 Jack Switch' off"
 ]

 Value {
  PlaybackPCM "hw:0,4"
  PlaybackChannels "2"
  JackControl "HDMI/DP, pcm=12 Jack"
 }
}

SectionDevice."HDMI3" {
 Comment "HDMI3/DP3 Output"

 EnableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='hif7-0 Jack Switch' on"
  cset "name='Pin7-Port0 Mux' 3"
 ]

 DisableSequence [
  cdev "hw:sofsklhdacard"
  cset "name='Pin7-Port0 Mux' 0"
  cset "name='hif7-0 Jack Switch' off"
 ]

 Value {
  PlaybackPCM "hw:0,5"
  PlaybackChannels "2"
  JackControl "HDMI/DP, pcm=13 Jack"
 }
}
EOT
echo finished creating  /usr/share/alsa/ucm/sof-skl_hda_card/HiFi.conf -------

echo creating file /usr/share/alsa/ucm/sof-skl_hda_card/sof-skl_hda_card.conf ------
cat <<EOT >> /usr/share/alsa/ucm/sof-skl_hda_card/sof-skl_hda_card.conf
SectionUseCase."HiFi" {
 File "HiFi.conf"
 Comment "Play HiFi quality Music"
}
EOT
echo finished creating  /usr/share/alsa/ucm/sof-skl_hda_card/sof-skl_hda_card.conf   -------


echo "Reboot and run alsamixer. Use F6 to select the sound card and F4 to go to Capture, then turn all of the channels up to 100"

echo "If there is no sound card detected, ‘dmesg | grep sof’ can be used to see what went wrong"
