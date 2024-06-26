#!/bin/bash
 if [ "$(id -u)" -ne 0 ]; then
     echo "Please run this script with sudo:"
     echo "sudo $0"
     exit 1
 fi

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
			pacman --noconfirm -Syu
		fi

		clear
		echo "Installing required packages for ChrisTileOS..."
		sleep 5

		pacman --noconfirm -S qtile # Window Manager
		pacman --noconfirm -S sddm # Display Manager(login manager)
		pacman --noconfirm -S mpv # For login,logout,lock,reboot and shutdown sounds
		pacman --noconfirm -S xscreensaver # Screensaver
		pacman --noconfirm -S nitrogen # To set wallpapers
		pacman --noconfirm -S feh # To set wallpapers
		pacman --noconfirm -S rofi # For Application and power Laucher
		pacman --noconfirm -S arandr # To set Screen Resolution
		pacman --noconfirm -S nerd-fonts # For icons
		pacman --noconfirm -S xdg-user-dirs # Create user directories upon user creation
		pacman --noconfirm -S alacritty # Terminal Appliction
		pacman --noconfirm -S conky # System infomation overlay on desktop
		pacman --noconfirm -S lsd # coloured ls output
		pacman --noconfirm -S bat # replacement fot cat with coloured output
		pacman --noconfirm -S pavucontrol # Audio Control GUI
		pacman --noconfirm -S pipewire-pulse # Audio Control
		pacman --noconfirm -S base-devel # to build arch packages
		pacman --noconfirm -S git # to download git packages
		pacman --noconfirm -S qt5-graphicaleffects qt5-quickcontrols2 qt5-svg # for sddm theme
		pacman --noconfirm -S zsh # zsh Shell
		pacman --noconfirm -S zsh-history-substring-search # for zsh shell allows to search throught typed commands
		pacman --noconfirm -S zsh-syntax-highlighting # for the zsh shell will show vaild commands in green and invaild commands in red
		pacman --noconfirm -S zsh-autosuggestions # for the zsh shell wil show suggested typed commands
		pacman --noconfirm -S wget # To Download zsh-sudo and command-not-found plugin for zsh
  		pacman --noconfirm -S firefox # Default Web Browser
  		pacman --noconfirm -S python-psutil
		pacman --noconfirm -S pacman-contrib
		pacman --noconfirm -S pkgfile
		systemctl enable sddm

		cp -r corners /usr/share/sddm/themes/
		# mkdir /etc/sddm.conf.d/
		# cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf.d/default.conf.user
  		cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf
		sed -i s/Current=/Current=corners/ /etc/sddm.conf

	       if [[ ! -d /etc/skel/.config ]]; then
	       	  cp -r config /etc/skel/.config
               elif [[  -d /etc/skel/.config ]]; then
	          cp -r config/* /etc/skel/.config

                fi
		cp dot.xscreensaver /etc/skel/.xscreensaver
		cp dot.zshrc /etc/skel/.zshrc
		cp dot.bashrc /etc/skel/.bashrc

		chmod -R +x /etc/skel/.config/scripts/

		mkdir /usr/share/zsh/plugins/zsh-sudo
		wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /usr/share/zsh/plugins/zsh-sudo


		mkdir /usr/share/zsh/plugins/command-not-found
		wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh -P /usr/share/zsh/plugins/command-not-found
		pkgfile -u

		git clone https://github.com/romkatv/powerlevel10k.git /etc/skel/.config/powerlevel10k/
		cp dot.p10k.zsh /etc/skel/.p10k.zsh
		clear

        sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
        sed -i  's|SHELL=/usr/bin/bash|SHELL=/usr/bin/zsh|' /etc/default/useradd
        mv /usr/share/wayland-sessions/qtile-wayland.desktop /usr/share/wayland-sessions/qtile-wayland.desktop.bak




user_list=($(grep "/home/" /etc/passwd | awk -F : '{print $1}'))

# Function to find the full path to zsh
get_zsh_path() {
    if [[ -x /bin/zsh ]]; then
        echo "/bin/zsh"
    elif [[ -x /usr/bin/zsh ]]; then
        echo "/usr/bin/zsh"
    else
        echo "zsh not found" >&2
        exit 1
    fi
}

zsh_path=$(get_zsh_path)

if [[ ${#user_list[@]} -eq 0 ]]; then
    read -p "No users are detected with home directories, would you like to create one? (y/n): " yn
    if [[ $yn == "y" ]]; then
        read -p "Please enter a username: " username
        read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
        if [[ ! -z $username ]]; then
            useradd -m $username
            passwd $username
            if [[ $yn_sudo == "y" ]]; then
                sudo usermod -aG wheel $username
            fi
            user_list+=("$username")  # Add the new user to the list
        fi
    fi
fi

if [[ ${#user_list[@]} -gt 0 ]]; then
    while true; do
        echo "Existing users with home directories:"
        for ((i=0; i<${#user_list[@]}; i++)); do
            echo "$(($i + 1)). ${user_list[i]}"
        done

        read -p "Select a user to copy files to (or type 'add' to add another user, or 'skip' to skip to the next part): " selection

        if [[ "$selection" == "add" ]]; then
            read -p "Please enter a username: " username
            read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
            if [[ ! -z $username ]]; then
                useradd -m $username
                passwd $username
                if [[ $yn_sudo == "y" ]]; then
                    sudo usermod -aG wheel $username
                fi
                user_list+=("$username")  # Add the new user to the list
                echo "User $username added."
            fi
        elif [[ "$selection" == "skip" ]]; then
            break
        elif [[ $selection =~ ^[0-9]+$ && $selection -ge 1 && $selection -le ${#user_list[@]} ]]; then
            selected_user="${user_list[$(($selection - 1))]}"
            if [[ ! -d "/home/$selected_user/.config/" ]]; then
                echo "Creating .config directory and copying files..."
                cp -r config "/home/$selected_user/.config"
                chsh -s "$zsh_path" $selected_user
                cp dot.bashrc "/home/$selected_user/.bashrc"
		cp dot.p10k.zsh "/home/$selected_user/.p10k.zsh"
   		cp dot.xscreensaver "/home/$selected_user/.xscreensaver"
     		cp dot.zshrc "/home/$selected_user/.zshrc"
       		git clone https://github.com/romkatv/powerlevel10k.git "/home/$selected_user/.config/powerlevel10k"
	 	chown -R $selected_user:$selected_user "/home/$selected_user/.config/"
  		chmod -R +x "/home/$selected_user/.config/scripts/"
                
            else
		echo "Copying files..."
                cp -r config/* "/home/$selected_user/.config"
                chsh -s "$zsh_path" $selected_user
                cp dot.bashrc "/home/$selected_user/.bashrc"
		cp dot.p10k.zsh "/home/$selected_user/.p10k.zsh"
   		cp dot.xscreensaver "/home/$selected_user/.xscreensaver"
     		cp dot.zshrc "/home/$selected_user/.zshrc"
       		git clone https://github.com/romkatv/powerlevel10k.git "/home/$selected_user/.config/powerlevel10k"
	 	chown -R $selected_user:$selected_user "/home/$selected_user/.config/"
  		chmod -R +x "/home/$selected_user/.config/scripts/"
            fi
        else
            clear
            echo "Invalid selection. Please try again."
        fi
    done
fi










    fi
# If the user enters n then the install it exit
	if [[ $yn = n ]]; then
		echo "Exiting ChrisTileOS Installation..."
		sleep 5
		exit 0
	fi


