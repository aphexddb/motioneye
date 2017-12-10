# Motioneye on Pi Zero W w/Stretch Lite

Tested using Raspbian Stretch Light as of `2017-11-29`. [Download](https://downloads.raspberrypi.org/raspbian_lite_latest).

Motioneye runs on port 8765. To view after install completes: `http://<raspberry pi>:8765`.

## Flash Image

After flashing the sdcard, enable the camera and SSH.

* Enable SSH by creating empty file `ssh` to sdcard.
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

* make sure camera is working

    ```bash
    raspistill -v -o test.jpg
    ```

* Get the latest Raspbian stretch upgrades:

    ```bash
    sudo apt-get update -y && sudo apt-get dist-upgrade -y
    ```

* Install extra packages from the standard repos:

    ```bash
    sudo apt-get install -y libjpeg-dev libssl-dev libcurl4-openssl-dev libmariadbclient18 libpq5 mysql-common ffmpeg jq wget python-pip
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

