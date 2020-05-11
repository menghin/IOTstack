if [ -z "$var" ]; then
  echo "You must specify whether to install or upgrade docker."
  exit
fi

if [ "$EUID" -ne 0 ]
  then echo "Please run as root"
  exit
fi

if [ "$1" == "install" ]; then
  RESTART_REQUIRED="false"
  if command_exists docker; then
    echo "Docker already installed" >&2
  else
    RESTART_REQUIRED="true"
    echo "Install Docker" >&2
    curl -fsSL https://get.docker.com | sh
    usermod -aG docker $USER
  fi

  if command_exists docker-compose; then
    echo "docker-compose already installed" >&2
  else
    RESTART_REQUIRED="true"
    echo "Install docker-compose" >&2
    apt install -y docker-compose
  fi

  if [ "$RESTART_REQUIRED" == "true" ]; then
    if (whiptail --title "Restart Required" --yesno "It is recommended that you restart your device now. Select yes to do so now" 20 78); then
      reboot
    fi
  fi
fi

if [ "$1" == "upgrade" ]; then
  apt upgrade docker docker-compose
  
	if [ $? -eq 0 ]; then
		if (whiptail --title "Restart Required" --yesno "It is recommended that you restart your device now. Select yes to do so now" 20 78); then
			reboot
		fi
	fi
fi