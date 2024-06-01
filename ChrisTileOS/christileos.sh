clear
echo "Welcome to ChrisTileOS Install"
read -p "Would you like to start installing ChrisTileOS? (y/n) " yn

# If a user enters anything else but y or n, it will tell the user that it is invaild
	while [[ ! $yn = y ]] || [[ !$yn = n ]]; do
		clear
		echo "Invaild Input. You Entered $yn"
		read -p "Would you like to start installing ChrisTileOS? (y/n) " yn
	done

# If users enter y then the install will start
	if [[ $yn = y ]]; then
		read -p "Would you like to update? (y/n) " yn
		while [[ ! $yn = y ]] && [[ ! $yn = n ]]; do
			clear
			echo "Invaild Input! You Entered $yn"
			read -p "Would you like to update? (y/n) " yn
		done
		if [[ $yn = y ]]; then
			echo "Updating..."
			sleep 5
			sudo pacman --noconfirm -Syu
		fi

		clear
		echo "Installing required packages for ChrisTileOS..."
		sleep 5

		sudo pacman --noconfirm -S qtile # Window Manager
		sudo pacman --noconfirm -S sddm # Display Manager(login manager)
		sudo pacman --noconfirm -S mpv # For login,logout,lock,reboot and shutdown sounds
		sudo pacman --noconfirm -S xscreensaver # Screensaver
		sudo pacman --noconfirm -S nitrogen # To set wallpapers
		sudo pacman --noconfirm -S feh # To set wallpapers
		sudo pacman --noconfirm -S rofi # For Application and power Laucher
		sudo pacman --noconfirm -S arandr # To set Screen Resolution
		sudo pacman --noconfirm -S nerd-fonts # For icons
		sudo pacman --noconfirm -S xdg-user-dirs # Create user directories upon user creation 
		sudo pacman --noconfirm -S alacritty # Terminal Appliction 
		sudo pacman --noconfirm -S conky # System infomation overlay on desktop
		sudo pacman --noconfirm -S lsd # coloured ls output
		sudo pacman --noconfirm -S bat # replacement fot cat with coloured output
		sudo pacman --noconfirm -S pavucontrol # Audio Control GUI
		sudo pacman --noconfirm -S pipewire-pulse # Audio Control
		sudo pacman --noconfirm -S base-devel # to build arch packages
		sudo pacman --noconfirm -S git # to download git packages
		sudo pacman --noconfirm -S qt5-graphicaleffects qt5-quickcontrols2 qt5-svg # for sddm theme
		sudo pacman --noconfirm -S zsh # zsh Shell
		sudo pacman --noconfirm -S zsh-history-substring-search # for zsh shell allows to search throught typed commands
		sudo pacman --noconfirm -S zsh-syntax-highlighting # for the zsh shell will show vaild commands in green and invaild commands in red
		sudo pacman --noconfirm -S zsh-autosuggestions # for the zsh shell wil show suggested typed commands
		sudo pacman --noconfirm -S python-psutil
		sudo pacman --noconfirm -S pacman-contrib
		sudo pacman --noconfirm -S pkgfile
		sudo systemctl enable sddm
		
##### check from here
		sudo cp -r corners /usr/share/sddm/themes/
		sudo mkdir /etc/sddm.conf.d/
		sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf.d/default.conf.user
		sed -i s/Current=/Current=corners/ /etc/sddm.conf.d/default.conf.user

		sudo cp -r config /etc/skel/.config
		sudo cp dot.xscreensaver /etc/skel/.xscreensaver
		sudo cp dot.zshrc /etc/skel/.zshrc
		sudo cp dot.bashrc /etc/skel/.bashrc

		sudo chmod +x /etc/skel/.config/scripts/*
		
		sudo mkdir /user/share/zsh/plugins/zsh-sudo
		sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /user/share/zsh/plugins/zsh-sudo


		sudo mkdir /user/share/zsh/plugins/command-not-found
		sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh -P /user/share/zsh/plugins/command-not-found
		sudo pkgfile -u

		git clone https://github.com/romkatv/powerlevel10k.git /etc/skel/.config/powerlevel10k/
		cp dot.p10k.zsh /etc/skel/.p10k.zsh





	fi

# If the user enters n then the install it exit
	if [[ $yn = n ]]; then
		echo "Exiting ChrisTileOS Installation..."
		sleep 5
		exit 0
	fi





