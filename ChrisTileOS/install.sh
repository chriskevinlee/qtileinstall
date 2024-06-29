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
		sudo pacman --noconfirm -S wget # To Download zsh-sudo and command-not-found plugin for zsh
  		sudo pacman --noconfirm -S firefox # Default Web Browser
  		sudo pacman --noconfirm -S python-psutil
		sudo pacman --noconfirm -S pacman-contrib
		sudo pacman --noconfirm -S pkgfile
		sudo systemctl enable sddm
		
     ##### check from here
		sudo cp -r corners /usr/share/sddm/themes/
		sudo mkdir /etc/sddm.conf.d/
		sudo cp /usr/lib/sddm/sddm.conf.d/default.conf /etc/sddm.conf.d/default.conf.user
		sudo sed -i s/Current=/Current=corners/ /etc/sddm.conf.d/default.conf.user

		sudo cp -r config /etc/skel/.config
		sudo cp dot.xscreensaver /etc/skel/.xscreensaver
		sudo cp dot.zshrc /etc/skel/.zshrc
		sudo cp dot.bashrc /etc/skel/.bashrc

		sudo chmod +x /etc/skel/.config/scripts/*
		
		sudo mkdir /usr/share/zsh/plugins/zsh-sudo
		sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/sudo/sudo.plugin.zsh -P /usr/share/zsh/plugins/zsh-sudo


		sudo mkdir /usr/share/zsh/plugins/command-not-found
		sudo wget https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/plugins/command-not-found/command-not-found.plugin.zsh -P /usr/share/zsh/plugins/command-not-found
		sudo pkgfile -u

		sudo git clone https://github.com/romkatv/powerlevel10k.git /etc/skel/.config/powerlevel10k/
		sudo cp dot.p10k.zsh /etc/skel/.p10k.zsh
		clear

  	        sudo sed -i 's/# %wheel ALL=(ALL:ALL) ALL/%wheel ALL=(ALL:ALL) ALL/' /etc/sudoers
 	        sudo sed -i  's|SHELL=/usr/bin/bash|SHELL=/usr/bin/zsh|' /etc/default/useradd
            sudo mv /usr/share/wayland-sessions/qtile-wayland.desktop /usr/share/wayland-sessions/qtile-wayland.desktop.bak






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
            sudo useradd -m $username
            sudo passwd $username
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
                sudo useradd -m $username
                sudo passwd $username
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
                sudo cp -r config "/home/$selected_user/.config"
                sudo chmod +x "/home/$selected_user/.config/scripts/*"
                sudo chown -R $selected_user:$selected_user "/home/$selected_user/.config/"
                sudo chsh -s "$zsh_path" $selected_user
                cp dot.bashrc "/home/$selected_user/.bashrc"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.bashrc"
                git clone https://github.com/romkatv/powerlevel10k.git "/home/$selected_user/.config/powerlevel10k"
                cp dot.p10k.zsh "/home/$selected_user/.p10k.zsh"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.p10k.zsh"
                cp dot.xscreensaver "/home/$selected_user/.xscreensaver"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.xscreensaver"
                cp dot.zshrc "/home/$selected_user/.zshrc"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.zshrc"
            else
                sudo cp -r config/* "/home/$selected_user/.config"
                sudo chmod -R +x "/home/$selected_user/.config/scripts/"
                sudo chown -R $selected_user:$selected_user "/home/$selected_user/.config/"
                sudo chsh -s "$zsh_path" $selected_user
                cp dot.bashrc "/home/$selected_user/.bashrc"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.bashrc"
                git clone https://github.com/romkatv/powerlevel10k.git "/home/$selected_user/.config/powerlevel10k"
                cp dot.p10k.zsh "/home/$selected_user/.p10k.zsh"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.p10k.zsh"
                cp dot.xscreensaver "/home/$selected_user/.xscreensaver"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.xscreensaver"
                cp dot.zshrc "/home/$selected_user/.zshrc"
                sudo chown $selected_user:$selected_user "/home/$selected_user/.zshrc"
            fi
        else
            clear
            echo "Invalid selection. Please try again."
        fi
    done
fi















################################################

# user_list=($(grep "/home/" /etc/passwd | awk -F : '{print $1}'))

# if [[ ${#user_list[@]} -eq 0 ]]; then
#     read -p "No users are detected with home directories, would you like to create one? (y/n): " yn
#     if [[ $yn == "y" ]]; then
#         read -p "Please enter a username: " username
#         read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
#         if [[ ! -z $username ]]; then
#             sudo useradd -m $username
#             sudo passwd $username
#             if [[ $yn_sudo == "y" ]]; then
#                 sudo usermod -aG wheel $username
#             fi
#             user_list+=("$username")  # Add the new user to the list
#         fi
#     fi
# fi

# if [[ ${#user_list[@]} -gt 0 ]]; then
#     while true; do
#         echo "Existing users with home directories:"
#         for ((i=0; i<${#user_list[@]}; i++)); do
#             echo "$(($i + 1)). ${user_list[i]}"
#         done

#         read -p "Select a user to copy files to (or type 'add' to add another user, or 'skip' to skip to the next part): " selection

#         if [[ "$selection" == "add" ]]; then
#             read -p "Please enter a username: " username
#             read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
#             if [[ ! -z $username ]]; then
#                 sudo useradd -m $username
#                 sudo passwd $username
#                 if [[ $yn_sudo == "y" ]]; then
#                     sudo usermod -aG wheel $username
#                 fi
#                 user_list+=("$username")  # Add the new user to the list
#                 echo "User $username added."
#             fi
#         elif [[ "$selection" == "skip" ]]; then
#             break
#         elif [[ $selection =~ ^[0-9]+$ && $selection -ge 1 && $selection -le ${#user_list[@]} ]]; then
#             selected_user="${user_list[$(($selection - 1))]}"
#             if [[ ! -d "/home/$selected_user/.config/" ]]; then
#                 echo "Creating .config directory and copying files..."
#                 sudo cp -r config "/home/$selected_user/.config"
#                 sudo chmod +x "/home/$selected_user/.config/scripts/*"
#                 sudo chown -R $selected_user:$selected_user "/home/$selected_user/.config/"
#                 chsh -s /bin/zsh
# 		#sudo sed -i "s|^\(${selected_user}:.*:\)/usr/bin/bash$|\1/usr/bin/zsh|" /etc/passwd
#                 cp dot.bashrc "/home/$selected_user/.bashrc"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.bashrc"
# 		git clone https://github.com/romkatv/powerlevel10k.git "/home/$selected_user/.config/powerlevel10k"
#                 cp dot.p10k.zsh "/home/$selected_user/.p10k.zsh"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.p10k.zsh"
#                 cp dot.xscreensaver "/home/$selected_user/.xscreensaver"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.xscreensaver"
#                 cp dot.zshrc "/home/$selected_user/.zshrc"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.zshrc"
#             else
#                 echo "Copying files to existing .config directory..."
#                 sudo cp -r config/* "/home/$selected_user/.config"
#                 sudo chmod -R +x "/home/$selected_user/.config/scripts/"
#                 sudo chown -R $selected_user:$selected_user "/home/$selected_user/.config/"
#                 chsh -s /bin/zsh
# 		#sudo sed -i "s|^\(${selected_user}:.*:\)/usr/bin/bash$|\1/usr/bin/zsh|" /etc/passwd
#                 cp dot.bashrc "/home/$selected_user/.bashrc"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.bashrc"
# 		git clone https://github.com/romkatv/powerlevel10k.git "/home/$selected_user/.config/powerlevel10k"
#                 cp dot.p10k.zsh "/home/$selected_user/.p10k.zsh"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.p10k.zsh"
#                 cp dot.xscreensaver "/home/$selected_user/.xscreensaver"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.xscreensaver"
#                 cp dot.zshrc "/home/$selected_user/.zshrc"
#                 sudo chown $selected_user:$selected_user "/home/$selected_user/.zshrc"
#             fi
#         else
#             clear
#             echo "Invalid selection. Please try again."
#         fi
#     done
# fi

























































            # user_list=($(grep "/home/" /etc/passwd | awk -F : '{print $1}'))

			# if [[ ${#user_list[@]} -eq 0 ]]; then
			#     read -p "No users are detected with home directories, would you like to create one? (y/n): " yn
			#     if [[ $yn = y ]]; then
			#         read -p "Please enter a username: " username
			#         read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
			#         if [[ ! -z $username ]]; then
			#             sudo useradd -m $username
			#             sudo passwd $username
			#             if [[ $yn_sudo = y ]]; then
			#                 sudo usermod -aG wheel $username
			#             fi
			#             user_list+=($username)  # Add the new user to the list
			#         fi
			#     fi
			# fi

			# if [[ ${#user_list[@]} -gt 0 ]]; then
			#     while true; do
			#         echo "Existing users with home directories:"
			#         for ((i=0; i<${#user_list[@]}; i++)); do
			#             echo "$(($i + 1)). ${user_list[i]}"
			#         done

			#         read -p "Select a user to copy files to (or type 'add' to add another user, or 'skip' to skip to the next part): " selection

			#         if [[ "$selection" = "add" ]]; then
			#             read -p "Please enter a username: " username
			#             read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
			#             if [[ ! -z $username ]]; then
			#                 sudo useradd -m $username
			#                 sudo passwd $username
			#                 if [[ $yn_sudo = y ]]; then
			#                     sudo usermod -aG wheel $username
			#                 fi
			#                 user_list+=($username)  # Add the new user to the list
			#                 echo "User $username added."
			#             fi
			#         elif [[ "$selection" = "skip" ]]; then
			#             break
			#         elif [[ $selection =~ ^[0-9]+$ && $selection -ge 1 && $selection -le ${#user_list[@]} ]]; then
			#             selected_user="${user_list[$(($selection - 1))]}"
			#             if [[ ! -d "/home/$selected_user/.config/" ]]; then
			#                 echo "NO CONFIG DIR"
			#                 sleep 10
			#                 sudo cp -r config "/home/$selected_user/.config"
		   	# 				sudo chmod +x "/home/$selected_user/.config/scripts/*"
			# 				sudo chown -r $selected_user:$selected_user "/home/$selected_user/.config/
			#                 sudo sed -i "s|^\(${selected_user}:.*:\)/usr/bin/bash$|\1/usr/bin/zsh|" /etc/passwd
     		# 				cp dot.bashrc .bashrc
			# 		        sudo chown $selected_user:$selected_user
			# 				cp dot.p10k.zsh .p10k.zsh
			# 		        sudo chown $selected_user:$selected_user  	
			# 		        cp dot.xscreensaver .xscreensaver
			# 		        sudo chown $selected_user:$selected_user
			# 		        cp dot.zshrc .zshrc
			# 		        sudo chown $selected_user:$selected_user
			#             else
			#                 echo " NO CONFIG DIR"
			#                 sudo cp -r config/* "/home/$selected_user/.config"
		    #                 chmod +x "/home/$selected_user/.config/scripts/*"
			#                 sudo chown -r $selected_user:$selected_user "/home/$selected_user/.config/
			#                 sudo sed -i "s|^\(${selected_user}:.*:\)/usr/bin/bash$|\1/usr/bin/zsh|" /etc/passwd
            #                 cp dot.bashrc .bashrc
			# 		        sudo chown $selected_user:$selected_user
			# 		        cp dot.p10k.zsh .p10k.zsh
			# 		        sudo chown $selected_user:$selected_user  
			# 		        cp dot.xscreensaver .xscreensaver
			# 		        sudo chown $selected_user:$selected_user
			# 		        cp dot.zshrc .zshrc
			# 		       sudo chown $selected_user:$selected_user
			#             fi
			#         else
			#             clear
			#             echo "Invalid selection. Please try again."
			#         fi
			#     done
			# fi








		# user_list=($(grep "/home/" /etc/passwd | awk -F : '{print $1}'))

		# if [[ ${#user_list[@]} -eq 0 ]]; then
		#     read -p "No users are detected with home directories, would you like to create one? (y/n): " yn
		#     if [[ $yn = y ]]; then
		#         read -p "Please enter a username: " username
		#         read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
		#         if [[ ! -z $username ]]; then
		#             sudo useradd -m $username
		#             sudo passwd $username
		#             if [[ $yn_sudo = y ]]; then
		#                 sudo usermod -aG wheel $username
		#             fi
		#             user_list+=($username)  # Add the new user to the list
		#         fi
		#     fi
		# fi

		# if [[ ${#user_list[@]} -gt 0 ]]; then
		#     while true; do
		#         echo "Existing users with home directories:"
		#         for ((i=0; i<${#user_list[@]}; i++)); do
		#             echo "$(($i + 1)). ${user_list[i]}"
		#         done

		#         read -p "Select a user to copy files to (or type 'add' to add another user, or 'skip' to skip to the next part): " selection

		#         if [[ "$selection" = "add" ]]; then
		#             read -p "Please enter a username: " username
		#             read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
		#             if [[ ! -z $username ]]; then
		#                 sudo useradd -m $username
		#                 sudo passwd $username
		#                 if [[ $yn_sudo = y ]]; then
		#                     sudo usermod -aG wheel $username
		#                 fi
		#                 user_list+=($username)  # Add the new user to the list
		#                 echo "User $username added."
		#             fi
		#         elif [[ "$selection" = "skip" ]]; then
		#             break
		#         elif [[ $selection =~ ^[0-9]+$ && $selection -ge 1 && $selection -le ${#user_list[@]} ]]; then
		#             selected_user="${user_list[$(($selection - 1))]}"
		#             sudo cp -r config "/home/$selected_user/.config"
		#             sudo sed -i "s|^\(${selected_user}:.*:\)/usr/bin/bash$|\1/usr/bin/zsh|" /etc/passwd
		#         else
		#             clear
		#             echo "Invalid selection. Please try again."
		#         fi
		#     done
		# fi
    






    fi
# If the user enters n then the install it exit
	if [[ $yn = n ]]; then
		echo "Exiting ChrisTileOS Installation..."
		sleep 5
		exit 0
	fi



