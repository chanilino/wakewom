# Wake Wifi On mac detection

This is a script for openwrt. The idea is auto power on the wifi when you are going to __use__ it, and auto power off when you are __not__ going to use it. Your router power on the wifi when you activate the wifi of your device.

- It powers on the wifi when detects one or more hardware address previously configurated. 
- It powers off the wifi when there is no client connected in a time. This time is configurable too.

It needs tcpdump or tcpdump-mini installed to work. It needs that your wifi card supports monitor mode.

## Install on Openwrt

This project if prepared to run in Openwrt. This repo has the struct of new feed in openwrt. You can add the line to your _feeds.conf_ file:

> src-git wakewom https://github.com/chanilino/wakewom.git

For more info visit: 
https://wiki.openwrt.org/doc/devel/feeds


## Manual Installation

You can install manually on your openwrt:

- Copy wakewom.init to /etc/init.d/wakewom
- Copy wakewom.config to /etc/config/wakewom

Edit /etc/config/wakewom with your local config.

After that run:

/etc/init.d/wakewom start

If you want to install the service, so you have the service running after reboot:

/etc/init.d/wakewom enable

## License

This is the [License](https://raw.githubusercontent.com/chanilino/wakewom/master/LICENSE).



