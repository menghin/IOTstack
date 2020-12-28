# IOT Stack

IOTstack is a builder for docker-compose to easily make and maintain IoT stacks on the Raspberry Pi.

## Getting started

See [Getting Started](https://sensorsiot.github.io/IOTstack/Getting-Started) in the Wiki. It includes:

* A link to Andreas Spiess video #295 and #352.
* How to download the project (including constraints you need to observe).
* Running the menu to install Docker and set up your containers.
* Useful Docker commands (start \& stop the stack, manage containers).

See also the [documentation home page](https://sensorsiot.github.io/IOTstack/).

## New Installation
### Automatic
1. Run the following command:
```
curl -fsSL https://raw.githubusercontent.com/SensorsIot/IOTstack/master/install.sh | bash
```

### Manual
1. Install git
```
$ cd ~/IOTstack
$ git remote set-url origin https://github.com/SensorsIot/IOTstack.git
$ git pull origin master
$ git checkout master
$ docker-compose down
$ ./menu.sh
$ docker-compose up -d
```

## Need the old menu back?
```
cd ~/IOTstack/
git pull
git checkout old-menu
```

## Experimental Features

## Running
1. To enter the directory and run menu for installation options:
```
cd ~/IOTstack
bash ./menu.sh
```

2. Install docker with the menu, restart your system.

3. Run menu again to select your build options, then start docker-compose with
```
$ cd ~/IOTstack
$ git pull origin master
$ git checkout master
$ ./menu.sh
```

Want to have the latest and greatest features? Switch to the experimental branch:

```
$ cd ~/IOTstack
$ git pull origin master
$ git checkout experimental
$ ./menu.sh
```

Do note that the experimental branch may be broken, or may break your setup, so ensure you have a good backup, and please report any issues. The way back is:


## Contributions

Please use the [issues](https://github.com/SensorsIot/IOTstack/issues) tab to report issues.

## Need help? Have a feature suggestion? Discovered a bug?
We have a Discord server setup for discussions: [IOTstack Discord channel](https://discord.gg/ZpKHnks) if you want to comment on features, suggest new container types, or ask the IOTstack community for help.

You can also report bugs or suggestions to our Github: https://github.com/SensorsIot/IOTstack/issues

If you use some of the tools in the project please consider donating or contributing on their projects. It doesn't have to be monetary. Reporting bugs and creating Pull Requests helps improve the projects for everyone.

## Sidenotes

# Rebase from fork
git remote add upstream https://github.com/SensorsIot/IOTstack.git
git fetch upstream
git checkout master
git rebase upstream/master

# Setup on a CM4 with a CM4 IO-Board

Here the Lite version of RaspberrypiOS is used

How to flash the eMMC on a Raspberry Pi Compute Module 4 -> https://www.youtube.com/watch?v=jp_mF1RknU4

https://www.youtube.com/watch?v=KJRMjUzlHI8

How to Find Raspberry Pi IP Address: Try These Ways -> ping raspberrypi -> https://www.raspberrypistarterkits.com/how-to/find-raspberry-pi-ip-address/

# command before starting with iostack
passwd
sudo nano /etc/hostname (cm4)
sudo apt-get update
sudo apt-get upgrade

sudo apt-get install mc

# starting iostack
curl -fsSL https://raw.githubusercontent.com/SensorsIot/IOTstack/master/install.sh | bash
sudo reboot

Selected only grafana, nodered, mosquitto, pihole, mariadb, portainer-ce

cd ~/IOTstack
git remote set-url origin https://github.com/SensorsIot/IOTstack.git
git pull origin master
git checkout master
docker-compose down
./menu.sh
docker-compose up -d

# sensehat

https://pythonhosted.org/sense-hat/

one fix is required:
sudo nano /boot/config.txt
Scroll to the bottom of the file and add this line;
dtoverlay=rpi-sense

# generate your ssl certificate

https://mosquitto.org/man/mosquitto-tls-7.html

sudo apt-get install openssl
mkdir volumes/cert
cd columes/cert

openssl genrsa -des3 -out ca.key 2048
openssl req -new -x509 -days 1826 -key ca.key -out ca.crt
openssl genrsa -out server.key 2048
openssl req -new -out server.csr -key server.key
openssl x509 -req -in server.csr -CA ca.crt -CAkey ca.key -CAcreateserial -out server.crt -days 360

openssl rsa -in server.key -out server.key

# changes to mosquitto

http://www.steves-internet-guide.com/mosquitto-tls/
https://mosquitto.org/man/mosquitto-tls-7.html

modifications needed in compose and config (see changes in the template)

go into the mosquitto docker to create the password using the command:
mosquitto_passwd -c pwfile mosquitto

# changes to portainer-ce

modifications needed in compose

# changes to nodered

http://www.steves-internet-guide.com/securing-node-red-ssl/
https://discourse.nodered.org/t/using-command-line-access-with-the-docker-install/30434/5

in volumes/cert
openssl genrsa -out node-key.pem 2048
openssl req -new -sha256 -key node-key.pem -out node-csr.pem
openssl x509 -req -in node-csr.pem -signkey node-key.pem -out node-cert.pem

generate a password with
docker exec -it nodered npx node-red admin hash-pw

changes required to mysettings.js

# changes to grafana

https://grafana.com/docs/grafana/latest/installation/docker/#alpine-image-recommended
https://grafana.com/docs/grafana/latest/getting-started/getting-started/
https://community.grafana.com/t/grafana-https-configuration/524

mkdir ~/IOTstack/services/grafana
mkdir ~/IOTstack/services/grafana/config
docker cp grafana:/etc/grafana/ ~/IOTstack/services/grafana/config/
move directory content where grafana ini is to ~/IOTstack/services/grafana/config/

changes required to grafana.ini and compose

# issues i had
telegraf crashed because telegraf.conf was a directory
-> manually copied the config over from templates