<h1 align="center">BOOTMIESTER</h4>


<h4 align="center">Advanced Deauthenticating Script</h4>
<p align="center">
  <img src="https://img.shields.io/badge/contributions-welcome-brightgreen.svg?style=flat&label=Contributions&colorA=blue&colorB=black">
</p>
<p align="center"><a href="https://imgbb.com/"><img src="https://i.ibb.co/vkbZ0h2/Screenshot-from-2019-11-27-23-44-29.png" alt="Screenshot-from-2019-11-27-23-44-29" border="0"></a><br /><br />
</p>
Bootmiester is a light and fast shell script which is capable of deauthing connected devices from the access points within the range of your system's network adapter. 

Instead of manually switching your adapter mode and giving commands to the shell which could be time taking when trying to boot a bunch of selected devices, bootmiester helps you to deauth those specific devices in just a matter of seconds. 

### Installation
Run `install.sh` as sudo and it will automatically install bootmiester along with all the tools this script is using.
```
$ git clone https://github.com/Yashvendra/Bootmiester.git
$ cd Bootmiester
$ chmod +x install.sh
$ sudo ./install.sh
```

### Usage
Make sure you run this tool as super user
```
$ sudo bootmiester
```
Then follow the instructions on the terminal screen. Also make sure to let the packet scanning run for a good 6-8 seconds then press `ctrl+c` to stop capturing.

### Uninstallation
```
$ cd /root/bootmiester
$ sudo ./uninstall.sh
$ rm -rf /root/bootmiester
```

##### Upcoming Feature: Will daemonize the attaking phase and perform some simple tweaks to clean the output.
##### Note: This script is made for educational purposes and to help security researchers. Any actions or activities performed using this script is solely your responsibility.



