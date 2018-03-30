#!/bin/bash
# Alternative, less opinionated bash installer

THIS_D="$(dirname "${BASH_SOURCE[0]}")"

usage () {
	echo "usage: $0 /path/to/windows/install/directory"
	exit $1
}

if [ $# -ne 1 ]
then
	echo "Wrong number of arguments." 2>&1
	usage 1
fi

# Argument handling
install_d=$1

if [ ! -d  "$install_d" ]
then
	echo "$install_d is not a valid directory path." 2>&1
	usage 1
fi	

# Derive the (WINDOWS) path to the install directory.
winpath_install_d="$(
	_p="$(readlink -f "$install_d")"	# Resolve any links
	_p="${_p/\/mnt\/c/C:}"				# Use windows filesystem root
	echo "${_p//\//\\}"					# Swap for backslashes
)"
winpath_init_exe="$winpath_install_d\\wsl-init.vbs"

# Copy our scripts over, replacing the VBS script content with a real (win) path
cp -r $THIS_D/init.d $install_d
cp $THIS_D/wsl-init.bat $install_d
cp $THIS_D/wsl-init.sh $install_d
sed "s;%userprofile%\\\\wsl-init;$(printf "%q" "$winpath_install_d");" \
	$THIS_D/wsl-init.vbs > $install_d/wsl-init.vbs
echo "Scripts copied to specified installation directory."

esc_winpath_install_d="$(printf "%q" "$winpath_install_d")"
printf "Either create a shortcut to $esc_winpath_install_d\\\\wsl-init.vbs in "
printf "the Startup directory or set it up as a scheduled task.\n"

printf "\nCreate shortcut now? "
read answer
if [[ $answer = 'y' || $answer = 'Y' ]] 
then

	# Derive the user profile dir, preferably from an env var (e.g. in Git Bash)
	userprofile_d=$USERPROFILE
	if [[ -n $USERPROFILE ]]
	then
		userprofile_d=$USERPROFILE
	else
		userprofile_d=/mnt/c/Users/$USER
	fi

	if [ ! -d $userprofile_d ]
	then
		echo "Cannot find valid windows profile path for user $USER" 2>&1
		echo "Aborting; manually create the shortcut (or scheduled task)." 2>&1
		exit 1
	fi


	# Derive the user startup dir, preferably from an env var (e.g. in Git Bash)
	if [[ -n $APPDATA ]]
	then
		appdata_d=$APPDATA
	else
		appdata_d=$userprofile_d/AppData/Roaming
	fi

	if [[ ! -d $appdata_d ]]
	then
		echo "Cannot find valid windows user app data directory for $USER" 2>&1
		echo "Aborting; manually create the shortcut (or scheduled task)." 2>&1
		exit 1
	fi
	startup_d="$appdata_d/Microsoft/Windows/Start Menu/Programs/Startup"


	# Confirm whether to create the link as specified. Powershell normalises the
	# path so no need to do it here.
	startup_link="${startup_d/\/mnt\/c/}/wsl-init.lnk"
	printf "\nCreate shortcut $startup_link? "
    read answer
	if [[ $answer = 'y' || $answer = 'Y' ]]
	then
		startup_target="$winpath_init_exe"
		read -r -d '' ps_script <<-END
			\$s=(New-Object -COM WScript.Shell).CreateShortcut('$startup_link')
			\$s.TargetPath='$startup_target'
			\$s.Save()
		END
		echo "$ps_script" | powershell.exe
	fi
fi

exit 0
