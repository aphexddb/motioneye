# Motioneye on Pi Zero W w/Stretch Lite

Tested using Raspbian Stretch Light as of `2017-11-29`. [Download](https://downloads.raspberrypi.org/raspbian_lite_latest).

Motioneye runs on port 8765. To view after install completes: `http://<raspberry pi>:8765`. [Motion 4.0 guide](http://htmlpreview.github.io/?https://github.com/Motion-Project/motion/blob/4.0/motion_guide.html).

## Flash Image

After flashing the sdcard, enable the camera and SSH.

* Enable SSH by creating empty file `ssh` on sdcard.
* Enable wifi by adding `wpa_supplicant-wlan0.conf` to sdcard:
    ```txt
    country=US
    ctrl_interface=DIR=/var/run/wpa_supplicant GROUP=netdev
    update_config=1
    network={
    ssid="yourwifissidhere"
    psk="supersekret"
    }
    ```
* Enable camera by adding this to `config.txt` on sdcard:

    ```txt
    # start_x=1             # essential
    # gpu_mem=128           # at least, or maybe more if you wish
    # disable_camera_led=1  # optional, if you don't want the led to glow
    ```

    Alternatively, add this to your one-time scripted setup:

    ```bash
    printf "\n\n# enable camera\nstart_x=1\ngpu_mem=128\ndisable_camera_led=0\n" | sudo tee -a /boot/config.txt
    ```

## System Configuration

* update rpi (this requires reboot)

    ```bash
    sudo rpi-update
    ```

* Reboot: power cycle or `sudo shutdown -r now`

* Set a random hostname

    ```bash
    RAND=`cat /dev/urandom | base64 | head -c 5 | awk '{print toupper($0)}'`
    HOSTNAME="PiCam-$RAND"
    printf $HOSTNAME | sudo tee /etc/hostname
    sudo hostname $HOSTNAME
    printf "127.0.0.1       $HOSTNAME\n" | sudo tee -a /etc/hosts
    printf "127.0.1.1       $HOSTNAME\n" | sudo tee -a /etc/hosts
    sudo sed -i "s/raspberrypi/$HOSTNAME/" /etc/hosts
    ```

* Make sure camera is working

    ```bash
    raspistill -v -o test.jpg
    ```

* Ensure Pi HW camera is loaded on start

    ```bash
    printf "\nmodprobe bcm2835-v4l2" | sudo tee -a /etc/rc.local
    ```

* Get the latest Raspbian stretch upgrades:

    ```bash
    sudo apt-get update -y && sudo apt-get dist-upgrade -y
    ```

* Install extra packages from the standard repos:

    ```bash
    sudo apt-get install -y avahi-daemon libjpeg-dev libssl-dev libcurl4-openssl-dev libmariadbclient18 libpq5 mysql-common ffmpeg jq wget python-pip python-dev
    ```

* get and install pre-built motion package for stretch:

    ```bash
    wget https://github.com/Motion-Project/motion/releases/download/release-4.0.1/pi_stretch_motion_4.0.1-1_armhf.deb
    sudo dpkg -i pi_stretch_motion_4.0.1-1_armhf.deb
    ```

* install motioneye

    ```bash
    sudo pip install motioneye
    ```

* initial setup of config files and motioneye deamon:

    ```bash
    sudo mkdir -p /etc/motioneye
    sudo cp /usr/local/share/motioneye/extra/motioneye.conf.sample /etc/motioneye/motioneye.conf
    sudo mkdir -p /var/lib/motioneye
    sudo cp /usr/local/share/motioneye/extra/motioneye.systemd-unit-local /etc/systemd/system/motioneye.service
    sudo systemctl daemon-reload
    sudo systemctl enable motioneye
    sudo systemctl start motioneye
    ```

* Reboot: power cycle or `sudo shutdown -r now`

### Motion Config

Update motion.conf with `sudo vi /etc/motion/motion.conf`

```txt
# Restrict control connections to localhost only (default: on)
webcontrol_localhost off
```

...

```txt
# Image width (pixels). Valid range: Camera dependent, default: 352
width 1024

# Image height (pixels). Valid range: Camera dependent, default: 288
height 768

# Maximum number of frames to be captured per second.
# Valid range: 2-100. Default: 100 (almost no limit).
framerate 25
```

...

```txt
# Restrict stream connections to localhost only (default: on)
stream_localhost off
```

### Motioneye config

Update motioneye.conf with `sudo vi /etc/motioneye/motioneye.conf`

```txt
# whether motion HTTP control interface listens on
# localhost or on all interfaces
motion_control_localhost false
```

## Camera Control

To  pause and resume motion detection from a terminal or node-red etc. with commands:
curl http://picam:7999/1/detection/pause -s -o /dev/null
curl http://picam:7999/1/detection/start -s -o /dev/null