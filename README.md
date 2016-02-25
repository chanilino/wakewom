# Wake Wifi On mac detect

This is a script for openwrt. The idea is auto power on the wifi when you are going to use it, and auto power off when you are not going to use it. It works in this way. This power on is fired when you power on the wifi of your device.

- It powers on the wifi when detects one or more hardware address previously configurated. 
- It powers off the wifi when there is no client connected in a time. This time is configurable too.

It needs tcpdump or tcpdump-mini installed to work. It needs that your wifi card suppor monitor mode.

## Install
### Openwrt

This project if prepared to run in Openwrt. This repo has the struct of new feed in openwrt. For more info visit: 
https://wiki.openwrt.org/doc/devel/feeds


### Manual

You can install manually on your openwrt:

- Copy wakewom.init to /etc/init.d/wakewom
- Copy wakewom.config to /etc/config/wakewom

Edit /etc/config/wakewom with your local config.

After that run:

/etc/init.d/wakewom start

If you want to install the service, so you have the service running after reboot:

/etc/init.d/wakewom enable



