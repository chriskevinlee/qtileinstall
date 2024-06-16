		# Get a list of existing users with home directories

		user_list=($(grep "/home/" /etc/passwd | awk -F : '{print $1}'))

		if [[ ${#user_list[@]} -eq 0 ]]; then
		    read -p "No users are detected with home directories, would you like to create one? (y/n): " yn
		    if [[ $yn = y ]]; then
		        read -p "Please enter a username: " username
		        read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
		        if [[ ! -z $username ]]; then
		            sudo useradd -m $username
		            sudo passwd $username
		            if [[ $yn_sudo = y ]]; then
		                sudo usermod -aG wheel $username
		            fi
		            user_list+=($username)  # Add the new user to the list
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

		        if [[ "$selection" = "add" ]]; then
		            read -p "Please enter a username: " username
		            read -p "Would you like to make this user a sudo user? (y/n): " yn_sudo
		            if [[ ! -z $username ]]; then
		                sudo useradd -m $username
		                sudo passwd $username
		                if [[ $yn_sudo = y ]]; then
		                    sudo usermod -aG wheel $username
		                fi
		                user_list+=($username)  # Add the new user to the list
		                echo "User $username added."
		            fi
		        elif [[ "$selection" = "skip" ]]; then
		            break
		        elif [[ $selection =~ ^[0-9]+$ && $selection -ge 1 && $selection -le ${#user_list[@]} ]]; then
		            selected_user="${user_list[$(($selection - 1))]}"
		            sudo cp -r config "/home/$selected_user/.config"
		            echo "Config files copied to /home/$selected_user/.config"
		        else
		            clear
		            echo "Invalid selection. Please try again."
		        fi
		    done
		fi
	fi