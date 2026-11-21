![logo](logo.png)
===========

NEW: The BeagleLogic cape is here! To get more information please click [here]
(https://github.com/abhishek-kakkar/BeagleLogic/wiki/The-BeagleLogic-Cape).

Bootstrapped as a Google Summer of Code 2014 Project with BeagleBoard.org.

For detailed information and usage guide refer to
[the project wiki](https://github.com/abhishek-kakkar/BeagleLogic/wiki)

BeagleLogic realizes a logic analyzer on the BeagleBone / the BeagleBone Black using
the Programmable Real-Time units and matching firmware and Linux kernel modules on the
BeagleBone Black.

The software should also work on the BeagleBone White, but with limited memory support
(only 256 MB instead of 512 MB)

BeagleLogic can also be used in conjunction with the sigrok projects to capture and process
the data on the BeagleBone itself. The libsigrok bindings for BeagleLogic have been accepted
into the upstream libsigrok repository.

Directories:

* firmware: PRU Firmware
* kernel: Device Tree overlay source and kernel module source and Makefile.
**The default BeagleBone kernel v4.9.31-ti-r41 and above ship with BeagleLogic support.
You can verify it using the command** ```modinfo beaglelogic```
* server: Node.JS backend and static file server for the web interface
* cape: The cape design files (KiCAD schematic and PCB file only. Production Gerbers are available separately.)
* webapp: A minimal web client for BeagleLogic. Uses sigrok-cli internally for data
acquisition
* testapp: A simple test application that shows how to use the userspace API of BeagleLogic
and benchmarks memory copy speeds.
 
Selected binaries and archives related to the project may be downloaded from
[this link](http://goo.gl/770FTZ). Refer to the wiki for more information 
regarding the use of the archives and the binaries.

License
--------

 * **PRU firmware & Device tree overlay** : GPLv2
 * **Kernel Module**: GPLv2
 * **sigrok bindings**: GPLv3+
 * **Web interface** [/beaglelogic-server and /webapp]: MIT
 * **Cape** : CERN Open Hardware License
 * **Logo** : [Creative Commons Attribution-ShareAlike 4.0 International (CC-BY-SA-4.0)]
(http://creativecommons.org/licenses/by-sa/4.0/)

Сборка:

1. sudo apt install -y linux-headers-$(uname -r) build-essential git device-tree-compiler \
                    ti-pru-software-v6.0 ti-pru-cgt-v2.3

### Go to /opt
### git pull 
### cd Beaglelogic/kernel
2. sudo ln -sf /usr/lib/ti/pru-software-support-package-v6.0 /usr/lib/ti/pru-software-support-package

3. make -C /lib/modules/$(uname -r)/build M=$(pwd) modules

4. sudo make -C /lib/modules/$(uname -r)/build M=$(pwd) modules_install

5. sudo depmod -a

6. cd /opt/BeagleLogic/firmware

7. make clean && make

8. sudo cp release/beaglelogic-pru0.out /lib/firmware/beaglelogic-pru0-fw
   sudo cp release/beaglelogic-pru1.out /lib/firmware/beaglelogic-pru1-fw

9. dtc -O dtb -o /tmp/beaglelogic-00A0.dtbo -b 0 -@ /opt/BeagleLogic/kernel/beaglelogic-00A0.dts

10. sudo cp /tmp/beaglelogic-00A0.dtbo /lib/firmware/beaglelogic-00A0.dtbo

11. echo "beaglelogic" | sudo tee /etc/modules-load.d/beaglelogic.conf

12. 
sudo tee /etc/systemd/system/beaglelogic-setup.service << 'EOF'
[Unit]
Description=Allocate BeagleLogic DMA buffer
After=multi-user.target

[Service]
Type=oneshot
ExecStart=/bin/bash -c 'echo 134217728 > /sys/devices/virtual/misc/beaglelogic/memalloc && chmod 666 /dev/beaglelogic'
RemainAfterExit=yes

[Install]
WantedBy=multi-user.target
EOF

sudo systemctl daemon-reload
sudo systemctl enable beaglelogic-setup.service

sudo apt install -y sigrok-cli
