SYSU H3C Client
===
A CLI H3C Client for [OpenWRT](http://openwrt.org)

*Only tested in SYSU east campus*


Compilation
---
 - Compile with OpenWRT-SDK

 ```bash
 # Using ar71xx as example
 tar xjf OpenWrt-SDK-ar71xx-for-linux-x86_64-gcc-4.8-linaro_uClibc-0.9.33.2.tar.bz2
 cd OpenWrt-SDK-ar71xx-*
 # Get Makefile
 git clone git@github.com:chenhw2/sysuh3c.git -b openwrt package/sysuh3c
 # Select target package: Network -> sysuh3c
 make menuconfig
 # Compile
 make package/sysuh3c/compile V=99
 # To Add LuCI Support
 # Select target package: LuCI -> 3. Applications -> luci-app-sysuh3c
 make menuconfig
 # Compile
 make package/luci-app-sysuh3c/compile V=99
 ```

Usage
---
 ```bash
 -h --help        print help screen
 -u --username    user account
 -p --password    password
 -i --iface       network interface (default is eth0)
 -d --daemonize   daemonize
 -l --logoff      logoff
 ```