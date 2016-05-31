# Wake Wifi On Mac detection

This is a script for openwrt. The idea is auto power on the wifi when you are going to __use__ it, and auto power off when you are __not__ going to use it. Your router power on the wifi when you activate the wifi on your device.

- It powers on the wifi when detects one or more hardware address previously configurated. 
- It powers off the wifi when there is no client connected in a time. This time is configurable too.

It needs that your wifi card supports __monitor mode__.



## Install on Openwrt

You can  download the [installable file](https://github.com/chanilino/wakewom/releases/download/v1.0.0/wakewom_1.0.0-1_all.ipk)
from [downloads section](https://github.com/chanilino/wakewom/releases/download/)

Now you have to upload to your openwrt and  execute:
> opkg install wakewom_1.0.0-1_all.ipk





## Manual Installation

You can install manually on your openwrt:

- Copy [wakewom.init](https://github.com/chanilino/wakewom/raw/master/net/wakewom/files/wakewom.init) to /etc/init.d/wakewom
- Copy [wakewom.config](https://github.com/chanilino/wakewom/raw/master/net/wakewom/files/wakewom.config) to /etc/config/wakewom

Check that you have installed iw and tcpdump or tcpdump-mini on your openwrt. 


## First run

First check the configuration file has your info and the mac of your devices:

> /etc/config/wakewom

Start the service:

> /etc/init.d/wakewom start

If you want to install the service, so you have the service running after reboot:

> /etc/init.d/wakewom enable

## Build on Openwrt

This project if prepared to run in Openwrt. This repo has the struct of new feed in openwrt. You can add the line to your _feeds.conf_ file:

> src-git wakewom https://github.com/chanilino/wakewom.git

Now you can add the feed and create the package for install.

For more info visit: 
- https://wiki.openwrt.org/doc/devel/feeds
- https://wiki.openwrt.org/doc/howtobuild/single.package


## License

This is the [License](https://raw.githubusercontent.com/chanilino/wakewom/master/LICENSE).



