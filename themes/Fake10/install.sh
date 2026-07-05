#!/bin/bash
echo ""
echo -e "  mmmmmm        #             mmm     mmmm "
echo -e "  #       mmm   #   m   mmm     #    m\"  \"m"
echo -e "  #mmmmm \"   #  # m\"   #\"  #    #    #    #"
echo -e "  #      m\"\"\"#  #\"#    #\"\"\"\"    #    #    #"
echo -e "  #      \"mm\"#  #  \"m  \"#mm\"  mm#mm   #mm#"
echo ""
echo "by Honu"
echo "version 6"
echo ""
echo -e "This script will alter a ton of appearance settings, force persistent scroll bars, overwrite your panels and panel items, and install a startup script. You can view all the changes the script makes by reading the manual install section in the \"guide-and-info\" text file. Everything can be easily reverted, but it might take a while if you aren't that experienced." | fold -s -w $(tput cols)
echo ""
echo "Fake10 is designed for and works best with:"
echo "- Arch Linux"
echo "- Qubes OS"
echo ""
echo "Fake10 has been tested and works fine with:"
echo "- Debian"
echo ""
read -p ":: Would you like to continue? [Y/n] " answer
case $answer in
	[Nn] ) exit;;
	* ) ;;
esac
echo ""
theme=1                    # 1 for dark, 2 for light
color=0078D7               # accent color hex
xfwm_border=1              # if not qubes: 1 for standard, 2 for accent color
cursor=1                   # 1 for standard, 2 for inverted
start_icon=1               # in order: windows, xfce, arch, debian, fedora, mint, qubes
desktop_button=1           # 1 for standard(needs wmctrl), 2 for wide, 3 for none
set_bookmarks=false        # set standard windows bookmarks in thunar
set_docklike=false         # use docklike plugin instead of standard window buttons
install_wmctrls=false      # try to install wmctrl for the show desktop button
install_docklike=false     # try to install docklike taskbar
install_user_dirs=false    # try to install xdg user dirs
skip_panel_setup=false     # skip panel setup for qubes vms
tint_qubes_icons=true      # tint qube icons, false value patches the qube icon renderer
qubes_autoinstall=false    # patch css to improve window button icons and start menu for qubes
qubes_autoinstall_vm=false # patch css to improve tooltips for qubes vms
detected_qubes_dom=false
detected_qubes_vm=false
detected_arch=false
detected_debian=false
if [ -f /usr/bin/qubesdb-read ]; then
	vm_type=$(qubesdb-read /qubes-vm-type 2>/dev/null)
	if [ -n "$vm_type" ]; then
		detected_qubes_vm=true
	fi
fi
if [ -f /usr/bin/qubes-dom0-update ]; then
	detected_qubes_dom=true
fi
if command -v pacman &> /dev/null; then
	detected_arch=true
elif command -v apt &> /dev/null; then
	detected_debian=true
fi
echo -e "Please choose the theme you would like to apply. All assets will be installed regardless so you can easily change any option later:" | fold -s -w $(tput cols)
echo "1. Dark (original)"
echo "2. Light"
echo ""
while true; do
	read -p ":: Which theme would you like? [1-2] " answer
	if [[ "$answer" =~ ^[1-2]$ ]]; then
		theme="$answer"
		break
    	else
		echo "Invalid response! Try again."
    	fi
done
echo ""
if [ "$detected_qubes_dom" = "true" ]; then
	echo -e "It seems like you're using Qubes. Would you like the script to patch some CSS to make the theme look better with this OS?" | fold -s -w $(tput cols)
	echo ""
	read -p ":: Modify CSS? [Y/n] " answer
	case $answer in
		[Nn] ) ;;
		* ) qubes_autoinstall=true ;;
	esac
	echo ""
fi
if [ "$detected_qubes_vm" = "true" ]; then
	echo -e "You're able to customize Fake10 by setting an accent color, which behaves similarly to Windows 10. Utilizing this feature is highly recommended as it can help the theme complement your unique wallpaper/style. Since it seems like you're in a Qubes VM, you also can try setting the accent color to the VM color. You're able to change this later. Options available:" | fold -s -w $(tput cols)
else
	echo -e "You're able to customize Fake10 by setting an accent color, which behaves similarly to Windows 10. Utilizing this feature is highly recommended as it can help the theme complement your unique wallpaper/style. You're able to change this later. Options available:" | fold -s -w $(tput cols)
fi
echo -e "1. Customize and show all Windows 10 accent colors (recommended, opens image)"  | fold -s -w $(tput cols)
echo "2. Customize"
echo "3. Skip (use default blue)"
echo ""
skip_coloring=false
while true; do
	read -p ":: What would you like to do? [1-3] " answer
	if [[ "$answer" =~ ^[1-3]$ ]]; then
		case $answer in
		1)
			if [ "$detected_qubes_dom" = "true" ]; then
				echo "Opening image in disposable VM.."
				cat colors.png | qvm-run --pass-io --dispvm=$(qubes-prefs default_dispvm) "cat > /tmp/colors.png && xdg-open /tmp/colors.png" &> /dev/null &
			else
				echo "Opening image.."
				xdg-open colors.png
			fi
                ;;
		2) ;;
		3) skip_coloring=true ;;
		esac
		break
	else
        	echo "Invalid response! Try again."
	fi
done
echo ""
if [ "$skip_coloring" = "false" ]; then
	echo "Please input a hex code."
	echo ""
	while true; do
		read -p ":: Accent color code #" answer
		if [[ $answer =~ ^[0-9A-Fa-f]{6}$ ]]; then
			color="$answer"
			break
		else
			echo "Invalid response! Try again."
		fi
	done
	echo ""
fi
if [ "$detected_qubes_vm" = "true" ]; then
	echo -e "It seems like you're in a Qubes VM. Would you like the script to skip panel and desktop configuration? Choose no only if you're running a full desktop environment in this VM and know what you're doing." | fold -s -w $(tput cols)
	echo ""
	read -p ":: Skip panel setup? [Y/n] " answer
	case $answer in
		[Nn] ) ;;
		* ) skip_panel_setup=true;;
	esac
	echo ""
	echo -e "It seems like you're in a Qubes VM. Would you like the script to patch some CSS to make the theme look better with this OS?" | fold -s -w $(tput cols)
	echo ""
	read -p ":: Modify CSS? [Y/n] " answer
	case $answer in
		[Nn] ) ;;
		* ) qubes_autoinstall_vm=true;;
	esac
	echo ""
fi
if [ "$skip_panel_setup" = "false" ]; then
	if [ "$detected_qubes_dom" = "true" ]; then
		echo -e "Please choose a window border. You can easily change it later:" | fold -s -w $(tput cols)
		echo "1. Qubes Standard (no tinting)"
		echo "2. Qubes Colored (tint borders on focus)"
		echo "3. Qubes Colored (tint borders always)"
		echo "4. Qubes Colored (tint titlebar and border on focus)"
		echo "5. Qubes Colored (tint titlebar on focus, border always)"
		echo "6. Qubes Colorful (tint everything always)"
		echo ""
		while true; do
			read -p ":: Which window border would you like? [1-6] " answer
			if [[ "$answer" =~ ^[1-6]$ ]]; then
				xfwm_border="$answer"
				break
		    	else
				echo "Invalid response! Try again."
		    	fi
		done
		echo ""
		echo -e "Would you like to patch a Qubes script to disable icon coloring? This can be easily reverted. Say yes if you're going for a covert setup or appreciate non-tinted icons. Depending on your settings, this could make it slightly harder to differentiate VMs." | fold -s -w $(tput cols)
		echo ""
		read -p ":: Disable icon tinting? [y/N] " answer
		case $answer in
			[Yy] ) tint_qubes_icons=false;;
			* ) ;;
		esac
	else
		echo -e "Please choose a window border. You can easily change it later:" | fold -s -w $(tput cols)
		echo "1. Standard"
		echo "2. Accent Color"
		echo ""
		while true; do
			read -p ":: Which window border would you like? [1-2] " answer
			if [[ "$answer" =~ ^[1-2]$ ]]; then
				xfwm_border="$answer"
				break
		    	else
				echo "Invalid response! Try again."
		    	fi
		done
	fi
	echo ""
	echo -e "Please choose a mouse cursor theme. You can easily change it later:" | fold -s -w $(tput cols)
	echo "1. Default"
	echo "2. Evil (custom color-inverted dark cursors)"
	echo ""
	while true; do
		read -p ":: What mouse cursors would you like? [1-2] " answer
		if [[ "$answer" =~ ^[1-2]$ ]]; then
			cursor="$answer"
			break
	    	else
			echo "Invalid response! Try again."
	    	fi
	done
	echo ""
	echo -e "Please choose a Start menu icon. You can easily change it later:" | fold -s -w $(tput cols)
	echo "1. Windows 10"
	echo "2. XFCE"
	echo "3. Arch Linux"
	echo "4. Debian"
	echo "5. Qubes OS"
	echo ""
	while true; do
		read -p ":: Which Start menu icon would you like? [1-5] " answer
		if [[ "$answer" =~ ^[1-5]$ ]]; then
			start_icon="$answer"
			break
	    	else
			echo "Invalid response! Try again."
	    	fi
	done
	echo ""
	if [ -f /usr/lib/xfce4/panel/plugins/libdocklike.so ]; then
		echo -e "Would you like to use Docklike Taskbar instead of Window Buttons? This will make it look more like Windows 10. The default plugin is more mature, but Docklike has window previews. Make sure Docklike is version 0.5.1-1 or higher! You can change this later." | fold -s -w $(tput cols)
		echo ""
		read -p ":: Use plugin? [Y/n] " answer
		case $answer in
			[Nn] ) ;;
			* ) set_docklike=true;;
		esac
		echo ""
	else
		if [ "$detected_arch" = true ] && [ "$detected_qubes_dom" = false ]; then # docklike is too outdated on debian and looks terrible, don't even prompt
			echo -e "Would you like to install and use Docklike Taskbar instead of Window Buttons? This will make it look more like Windows 10. The default plugin is more mature, but Docklike has window previews. You can change this later." | fold -s -w $(tput cols)
			echo ""
			read -p ":: Install and use plugin? [Y/n] " answer
			case $answer in
				[Nn] ) ;;
				* )
					set_docklike=true
					install_docklike=true
				;;
			esac
			echo ""
		else
			if [ "$detected_qubes_dom" = false ]; then
				echo -e "\033[1;33mYou don't have XFCE Docklike Taskbar installed. If you install xfce4-docklike-plugin VERSION 0.5.1-1 OR HIGHER, this script can use it to look more like Windows 10.\033[0m" | fold -s -w $(tput cols)
				echo ""
			fi
		fi
	fi
	echo -e "Please choose a \"Show Desktop\" taskbar button. You can easily change it later:" | fold -s -w $(tput cols)
	if command -v wmctrl &> /dev/null; then
		echo "1. Standard" # qubes should have wmctrl already so I'm not handling it here
	else
		if [ "$detected_arch" = true -o "$detected_debian" = true ]; then
			echo "1. Standard (installs wmctrl)"
		else
			echo "1. Standard (requires wmctrl)"
		fi
	fi
	echo "2. Wide"
	echo "3. None"
	echo ""
	while true; do
		read -p ":: What button would you like? [1-3] " answer
		if [[ "$answer" =~ ^[1-3]$ ]]; then
			desktop_button="$answer"
			if ! command -v wmctrl &> /dev/null && [ "$desktop_button" = "1" ]; then
				install_wmctrls=true
			fi
			break
	    	else
			echo "Invalid response! Try again."
	    	fi
	done
	echo ""
fi
if command -v xdg-user-dirs-update &> /dev/null; then
	echo -e "Would you like to bookmark some XDG user directories in Thunar? This will make it look more like Windows 10." | fold -s -w $(tput cols)
	echo ""
	read -p ":: Add bookmarks? [Y/n] " answer
	case $answer in
		[Nn] ) ;;
		* ) set_bookmarks=true;;
	esac
	echo ""
else
	if [ "$detected_arch" = true -o "$detected_debian" = true ] && [ "$detected_qubes_dom" = false ]; then
		echo -e "Would you like to install and bookmark some XDG user directories in Thunar? This will make it look more like Windows 10." | fold -s -w $(tput cols)
		echo ""
		read -p ":: Install and add bookmarks? [Y/n] " answer
		case $answer in
			[Nn] ) ;;
			* ) 
				set_bookmarks=true
				install_user_dirs=true
			;;
		esac
	else
		echo -e "\033[1;33mYou don't have XDG User Directories installed. If you install xdg-user-dirs, this script can create and bookmark directories in Thunar to look more like Windows 10.\033[0m" | fold -s -w $(tput cols)
	fi
	echo ""
fi
if [ "$skip_panel_setup" = "false" ]; then
	echo -e "\033[1;33mPlease close any menu related to the XFCE panel and panel plugins! If the script errors on panel setup, run the reset command in the guide.\033[0m" | fold -s -w $(tput cols)
	echo ""
fi
step=${step:-0}
prog() {
	local prefixes=(
		"| #   # |"
		"|  # #  |"
		"|   #   |"
		"|  # #  |"
		"| #   # |"
		"|  # #  |"
		"|   #   |"
		"|  # #  |"
	)
	echo "${prefixes[$step]} $*"
	step=$(((step + 1) % 8 ))
	sleep 0.4 # so user can kill if a task errors
}
echo "Press any key to install..."
read -n 1 -s -r
package_failure=false
if [ "$install_user_dirs" = "true" ]; then
	if [ "$detected_arch" = "true" ]; then
		sudo pacman -Sy xdg-user-dirs || \
		package_failure=true
	elif [ "$detected_debian" = "true" ]; then
		echo "[sudo] password for root:"
		su -c "apt-get update -qq && apt-get install xdg-user-dirs" root 2>/dev/null || \
		sudo sh -c "apt-get update -qq && apt-get install xdg-user-dirs" || \
		package_failure=true
	fi
fi
if [ "$install_docklike" = "true" ]; then
	if [ "$detected_arch" = "true" ]; then
		sudo pacman -Sy xfce4-docklike-plugin || \
		package_failure=true
	fi
fi
if [ "$install_wmctrls" = "true" ]; then
	if [ "$detected_arch" = "true" ]; then
		sudo pacman -Sy wmctrl || \
		package_failure=true
	elif [ "$detected_debian" = "true" ]; then
		echo "[sudo] password for root:"
		su -c "apt-get update -qq && apt-get install wmctrl" root 2>/dev/null || \
		sudo sh -c "apt-get update -qq && apt-get install wmctrl" || \
		package_failure=true
	else
		echo ""
		echo -e "\033[1;33mYou don't have the wmctrl package, which is required for the \"Show Desktop\" button you selected. Please manually install wmctrl and try again.\033[0m" | fold -s -w $(tput cols)
		package_failure=true
	fi
fi
echo ""
if [ "$package_failure" = "true" ]; then
	echo -e "\033[1;33mOne or more packages failed installation! Suiciding.\033[0m" | fold -s -w $(tput cols)
	echo ""
	exit
fi
prog "Creating directories"
mkdir -p ~/.local/share/fonts
mkdir -p ~/.local/bin
mkdir -p ~/.local/share/xfce4/terminal/colorschemes
mkdir -p ~/.icons
mkdir -p ~/.themes
mkdir -p ~/.config/autostart
mkdir -p ~/.config/gtk-3.0
mkdir -p ~/.local/share/mime/packages/
prog "Copying fonts"
cp -r ./Fonts/* ~/.local/share/fonts
prog "Copying mimes"
cp -r ./Mimes/* ~/.local/share/mime/packages/
prog "Updating mime database"
update-mime-database ~/.local/share/mime/ > /dev/null 2>&1
prog "Copying icons"
cp -r ./Icons/* ~/.icons
prog "Creating icon cache"
gtk-update-icon-cache -f -t -q ~/.icons/Fake10/
gtk-update-icon-cache -f -t -q "$HOME/.icons/Fake10 Light/"
prog "Copying scripts"
cp -r ./Scripts/* ~/.local/bin/
prog "Changing script permissions"
chmod +x ~/.local/bin/show-desktop.sh
chmod +x ~/.local/bin/reload-theme.sh
prog "Copying themes"
cp -r ./Terminal/* ~/.local/share/xfce4/terminal/colorschemes
cp -r ./Themes/* ~/.themes
if [ "$detected_qubes_dom" = "true" ]; then
	cp -r ./Qubes/Themes/* ~/.themes
fi
prog "Changing accent color"
sed -i "s/0078D7/$color/g" ~/.themes/Fake10/gtk-3.0/gtk.css
sed -i "s/0078D7/$color/g" "$HOME/.themes/Fake10 Accent Color/xfwm4/themerc"
sed -i "s/0078D7/$color/g" "$HOME/.themes/Fake10 Light/gtk-3.0/gtk.css"
sed -i "s/0078D7/$color/g" "$HOME/.themes/Fake10 Light Accent Color/xfwm4/themerc"
if [ "$qubes_autoinstall" = "true" ]; then
	prog "Modifying CSS for Qubes"
	sed -i "s/margin-left: 5px; \\/\\* change me to 9px for qubes \\*\\//margin-left: 9px;/" ~/.themes/Fake10/gtk-3.0/gtk.css
	sed -i "s/margin-left: 9px; \\/\\* change me to 13px for qubes \\*\\//margin-left: 13px;/" ~/.themes/Fake10/gtk-3.0/gtk.css
	sed -i "s/min-width: 30px; \\/\\* fix offset from persistent scrollbar \\*\\//min-width: 36px;/" ~/.themes/Fake10/gtk-3.0/gtk.css
	sed -i "s/margin-right: -5px; \\/\\* change me to -11px for qubes \\*\\//margin-right: -11px;/" ~/.themes/Fake10/gtk-3.0/gtk.css
	sed -i "s/margin-left: 5px; \\/\\* change me to 9px for qubes \\*\\//margin-left: 9px;/" "$HOME/.themes/Fake10 Light/gtk-3.0/gtk.css"
	sed -i "s/margin-left: 9px; \\/\\* change me to 13px for qubes \\*\\//margin-left: 13px;/" "$HOME/.themes/Fake10 Light/gtk-3.0/gtk.css"
	sed -i "s/min-width: 30px; \\/\\* fix offset from persistent scrollbar \\*\\//min-width: 36px;/" "$HOME/.themes/Fake10 Light/gtk-3.0/gtk.css"
	sed -i "s/margin-right: -5px; \\/\\* change me to -11px for qubes \\*\\//margin-right: -11px;/" "$HOME/.themes/Fake10 Light/gtk-3.0/gtk.css"
fi
if [ "$tint_qubes_icons" = "false" ]; then
	prog "Modifying Qubes icon receiver"
	sudo sed -i "s/icon_tinted = icon\.tint(color)/icon_tinted = icon/" /usr/lib/qubes/icon-receiver
fi
if [ "$qubes_autoinstall_vm" = "true" ]; then
	prog "Modifying CSS for Qubes VM"
	sed -i "s/background-color: transparent; \\/\\* change to @main for qubes vms \\*\\//background-color: @main;/" ~/.themes/Fake10/gtk-3.0/gtk.css
	sed -i "s/background-color: transparent; \\/\\* change to white for qubes vms \\*\\//background-color: white;/" "$HOME/.themes/Fake10 Light/gtk-3.0/gtk.css"
fi
prog "Applying theme"
if [ "$theme" = "1" ]; then
	xfconf-query -c xsettings -p /Net/ThemeName -s "Fake10"
else
	xfconf-query -c xsettings -p /Net/ThemeName -s "Fake10 Light"
fi
if [ "$skip_panel_setup" = "false" ]; then
	if [ "$detected_qubes_dom" = "true" ]; then
		if [ "$theme" = "1" ]; then
			case $xfwm_border in
				1) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Standard" ;;
				2) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 1" ;;
				3) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 2" ;;
				4) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 3" ;;
				5) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 4" ;;
				6) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colorful" ;;
			esac
		else
			case $xfwm_border in
				1) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Standard Light" ;;
				2) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 1 Light" ;;
				3) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 2 Light" ;;
				4) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 3 Light" ;;
				5) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colored 4 Light" ;;
				6) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Qubes Colorful" ;;
			esac	
		fi
	else
		if [ "$theme" = "1" ]; then
			case $xfwm_border in
				1) xfconf-query -c xfwm4 -p /general/theme -s "Fake10" ;;
				2) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Accent Color" ;;
			esac
		else
			case $xfwm_border in
				1) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Light" ;;
				2) xfconf-query -c xfwm4 -p /general/theme -s "Fake10 Light Accent Color" ;;
			esac
		fi
	fi
	prog "Configuring windows"
	xfconf-query -c xfwm4 -p /general/title_font -s "Segoe UI 9"
	xfconf-query -c xfwm4 -p /general/title_alignment -s "left"
	xfconf-query -c xfwm4 -p /general/button_layout -s "O|HMC"
fi
prog "Applying icon theme"
if [ "$theme" = "1" ]; then
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Fake10"
else
	xfconf-query -c xsettings -p /Net/IconThemeName -s "Fake10 Light"
fi
prog "Applying cursor theme"
if [ "$theme" = "1" ]; then
	case $cursor in
		1) xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Fake10" ;;
		2) xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Fake10 Evil" ;;
	esac
else
	case $cursor in
		1) xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Fake10 Light" ;;
		2) xfconf-query -c xsettings -p /Gtk/CursorThemeName -s "Fake10 Light Evil" ;;
	esac
fi
prog "Reloading fonts"
rm -rf ~/.cache/fontconfig && rm -rf ~/.fontconfig && fc-cache -r
prog "Applying fonts"
xfconf-query -c xsettings -p /Gtk/FontName -s "Segoe UI 9"
xfconf-query -c xsettings -p /Gtk/MonospaceFontName -s "Consolas 12"
xfconf-query -c xsettings -p /Xft/HintStyle -t string -s hintfull --create
prog "Enabling persistent scroll bars"
touch ~/.bash_profile
touch ~/.profile
touch ~/.xsessionrc
if ! grep -q "export GTK_OVERLAY_SCROLLING=0" ~/.bash_profile; then
	echo "export GTK_OVERLAY_SCROLLING=0" >> ~/.bash_profile
fi
if ! grep -q "export GTK_OVERLAY_SCROLLING=0" ~/.profile; then
	echo "export GTK_OVERLAY_SCROLLING=0" >> ~/.profile
fi
if ! grep -q "export GTK_OVERLAY_SCROLLING=0" ~/.xsessionrc; then
	echo "export GTK_OVERLAY_SCROLLING=0" >> ~/.xsessionrc
fi
prog "Disabling DPI scaling"
xfconf-query -c xsettings -p /Xft/DPI -t int -s -1 --create
prog "Setting font subpixel order to RGB"
xfconf-query -c xsettings -p /Xft/RGBA -s "rgb"
prog "Disabling GTK button images"
xfconf-query -c xsettings -p /Gtk/ButtonImages -t bool -s false --create
prog "Disabling GTK dialog header bars"
xfconf-query -c xsettings -p /Gtk/DialogsUseHeader -t bool -s false --create
if [ "$skip_panel_setup" = "false" ]; then
	prog "Deleting old panels"
	xfce4-panel -r
	sleep 3.6
	xfconf-query -c xfce4-panel -p /panels -r -R
	xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -t int -s -1 -a --create
	xfce4-panel -r
	sleep 3.6
	prog "Configuring taskbar"
	xfconf-query -c xfce4-panel -p /panels/panel-1/size -t int -s 40 --create
	xfconf-query -c xfce4-panel -p /panels/panel-1/length -t int -s 100 --create
	xfconf-query -c xfce4-panel -p /panels/panel-1/length-adjust -t bool -s true --create
	xfconf-query -c xfce4-panel -p /panels/panel-1/position -t string -s "p=8;x=0;y=0" --create
	xfconf-query -c xfce4-panel -p /panels/panel-1/position-locked -t bool -s true --create
	xfconf-query -c xfce4-panel -p /panels/panel-1/background-style -t uint -s 1 --create
	if [ "$theme" = "1" ]; then
		xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -t double -t double -t double -t double -s 0.0627 -s 0.0627 -s 0.0627 -s 1.0 --create
		xfconf-query -c xfce4-panel -p /panels/dark-mode -t bool -s true --create
	else
		xfconf-query -c xfce4-panel -p /panels/panel-1/background-rgba -t double -t double -t double -t double -s 0.9333 -s 0.9333 -s 0.9333 -s 1.0 --create
	fi
	xfconf-query -c xfce4-panel -p /panels/panel-1/icon-size -t uint -s 24 --create
	xfconf-query -c xfce4-panel -p /panels/panel-1/plugin-ids -t int -s -1 -a --create
	prog "Creating taskbar items"
	xfce4-panel --add=whiskermenu
	if [ "$set_docklike" = "true" ]; then
		xfce4-panel --add=docklike
	else
		xfce4-panel --add=tasklist
	fi
	xfce4-panel --add=separator
	xfce4-panel --add=systray
	xfce4-panel --add=pulseaudio
	xfce4-panel --add=clock
	xfce4-panel --add=notification-plugin
	case $desktop_button in
		1) xfce4-panel --add=genmon;;
		2) xfce4-panel --add=showdesktop ;;
		3) xfce4-panel --add=separator ;;
	esac
	prog "Configuring taskbar items"
	xfconf-query -c xfce4-panel -p /plugins/plugin-3/expand -t bool -s true --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-3/style -t int -s 0 --create
	if [ "$set_docklike" = "true" ]; then
cat > ~/.config/xfce4/panel/docklike-2.rc << EOF
[user]
showPreviews=true
middleButtonBehavior=1
indicatorStyle=5
inactiveIndicatorStyle=5
forceIconSize=true
iconSize=24
EOF
	else
		xfconf-query -c xfce4-panel -p /plugins/plugin-2/show-handle -t bool -s false --create
		xfconf-query -c xfce4-panel -p /plugins/plugin-2/sort-order -t int -s 4 --create
		xfconf-query -c xfce4-panel -p /plugins/plugin-2/grouping -t int -s 1 --create
	fi
	xfconf-query -c xfce4-panel -p /plugins/plugin-4/icon-size -t int -s 16 --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-4/square-icons -t bool -s true --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-6/digital-time-font -t string -s "Segoe UI 9" --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-6/digital-date-font -t string -s "Segoe UI 9" --create
	case $desktop_button in
		1)
			xfconf-query -c xfce4-panel -p /plugins/plugin-8/command -t string -s "echo \"<img></img><click>/home/$USER/.local/bin/show-desktop.sh</click><tool>Show Desktop</tool>\"" --create
			xfconf-query -c xfce4-panel -p /plugins/plugin-8/update-period -t int -s 86400000 --create
			xfconf-query -c xfce4-panel -p /plugins/plugin-8/use-label -t bool -s false --create
			cat > ~/.config/xfce4/panel/genmon-8.rc << EOF
Command=echo "<img></img><click>/home/USER/.local/bin/show-desktop.sh</click><tool>Show Desktop</tool>"
UseLabel=0
Text=(genmon)
UpdatePeriod=86400000
Font=Segoe UI 9
EOF
			sed -i "s/USER/$USER/g" ~/.config/xfce4/panel/genmon-8.rc # legacy support
		;;
		2) ;;
		3) xfconf-query -c xfce4-panel -p /plugins/plugin-8/style -t int -s 0 --create ;;
	esac
	prog "Configuring Start menu"
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/category-show-name -t bool -s false --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/launcher-show-description -t bool -s false --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/category-icon-size -t int -s 0 --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/position-categories-alternate -t bool -s true --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/position-search-alternate -t bool -s true --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/position-commands-alternate -t bool -s true --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/profile-shape -t int -s 2 --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/confirm-session-command -t bool -s false --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-command-settings -t bool -s false --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-command-lockscreen -t bool -s false --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-command-shutdown -t bool -s true --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/show-command-logout -t bool -s false --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/menu-height -t int -s 640 --create
	xfconf-query -c xfce4-panel -p /plugins/plugin-1/menu-width -t int -s 392 --create
	prog "Applying Start menu icon"
	if [ "$theme" = "1" ]; then
		case $start_icon in
			1) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-windows" --create ;;
			2) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-xfce" --create ;;
			3) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-arch" --create ;;
			4) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-debian" --create ;;
			5) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-qubes" --create ;;
		esac
	else
		case $start_icon in
			1) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-windows-light" --create ;;
			2) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-xfce-light" --create ;;
			3) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-arch-light" --create ;;
			4) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-debian-light" --create ;;
			5) xfconf-query -c xfce4-panel -p /plugins/plugin-1/button-icon -t string -s "start-menu-qubes-light" --create ;;
		esac
	fi
	prog "Creating Start menu keybinds"
	xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/Super_L" -t string -s "xfce4-popup-whiskermenu" --create
	xfconf-query -c xfce4-keyboard-shortcuts -p "/commands/custom/Super_R" -t string -s "xfce4-popup-whiskermenu" --create
	prog "Disabling dock shadows"
	xfconf-query -c xfwm4 -p /general/show_dock_shadow -t bool -s false --create
	prog "Enabling startup script"
cat > ~/.config/autostart/script.desktop << EOF
[Desktop Entry]
Type=Application
Exec=$HOME/.local/bin/reload-theme.sh
Hidden=false
NoDisplay=false
X-GNOME-Autostart-enabled=true
Name=Fake10 Reload Theme on Logon
Comment=Fixes taskbar issues
EOF
	prog "Configuring notifications"
	xfconf-query -c xfce4-notifyd -p /do-fadeout -t bool -s false --create
	xfconf-query -c xfce4-notifyd -p /do-slideout -t bool -s true --create
	if [ "$theme" = "1" ]; then
		xfconf-query -c xfce4-notifyd -p /theme -t string -s "Fake10" --create
	else
		xfconf-query -c xfce4-notifyd -p /theme -t string -s "Fake10 Light" --create
	fi
	xfconf-query -c xfce4-notifyd -p /notify-location -t uint -s 3 --create
	xfconf-query -c xfce4-notifyd -p /initial-opacity -t double -s 1.0 --create
	xfconf-query -c xfce4-notifyd -p /notification-log -t bool -s true --create
	xfconf-query -c xfce4-notifyd -p /log-level --create -t uint -s 1
	xfconf-query -c xfce4-notifyd -p /plugin/hide-clear-prompt --create -t bool -s true
	prog "Configuring desktop"
	xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-home -t bool -s false --create
	xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-filesystem -t bool -s false --create
	xfconf-query -c xfce4-desktop -p /desktop-icons/file-icons/show-removable -t bool -s false --create
	xfconf-query -c xfce4-desktop -p /desktop-icons/icon-size -t int -s 48 --create
	xfconf-query -c xfwm4 -p /general/workspace_count -t int -s 1 --create
	prog "Disabling lock screen user switching"
	xfconf-query -c xfce4-screensaver -p /lock/user-switching/enabled -t bool -s false --create
fi
prog "Configuring terminal"
xfconf-query -c xfce4-terminal -p /title-initial -t string -s "Command Prompt" --create
xfconf-query -c xfce4-terminal -p /title-mode -t string -s "TERMINAL_TITLE_HIDE" --create
xfconf-query -c xfce4-terminal -p /misc-cursor-shape -t string -s "TERMINAL_CURSOR_SHAPE_UNDERLINE" --create
xfconf-query -c xfce4-terminal -p /misc-cursor-blinks -t bool -s true --create
xfconf-query -c xfce4-terminal -p /font-name -t string -s "Consolas 11" --create
xfconf-query -c xfce4-terminal -p /font-allow-bold -t bool -s false --create
xfconf-query -c xfce4-terminal -p /misc-menubar-default -t bool -s false --create
xfconf-query -c xfce4-terminal -p /color-foreground -t string -s "#CCCCCC" --create
xfconf-query -c xfce4-terminal -p /color-background -t string -s "#0C0C0C" --create
xfconf-query -c xfce4-terminal -p /color-palette -t string -s "#0C0C0C;#C50F1F;#13A10E;#C19C00;#0037DA;#881798;#3A96DD;#CCCCCC;#767676;#E74856;#16C60C;#F9F1A5;#3B78FF;#B4009E;#61D6D6;#F2F2F2" --create
prog "Configuring file explorer"
xfconf-query -c thunar -p /shortcuts-icon-size -t string -s "THUNAR_ICON_SIZE_16" --create
xfconf-query -c thunar -p /last-toolbar-items -t string -s "back:1,forward:1,open-parent:1,location-bar:1,search:1" --create
xfconf-query -c thunar -p /last-location-bar -t string -s "ThunarLocationButtons" --create
if [ "$set_bookmarks" = "true" ]; then
	prog "Configuring file explorer bookmarks"
	xfconf-query -c thunar -p /hidden-bookmarks --create --type string --set 'trash:///' --type string --set 'recent:///'
	xdg-user-dirs-update
	touch ~/.config/gtk-3.0/bookmarks
	for dir in Documents Downloads Music Pictures Videos; do
		bookmark="file://$HOME/$dir"
		grep -qF "$bookmark" "$HOME/.config/gtk-3.0/bookmarks" || echo "$bookmark" >> "$HOME/.config/gtk-3.0/bookmarks"
	done
fi
prog "Configuring image viewer"
xfconf-query -c ristretto -p /window/toolbar/show -t bool -s false --create
xfconf-query -c ristretto -p /window/statusbar/show -t bool -s false --create
echo ""
echo -e "Script finished. You're 95% there! Please follow the instructions below:" | fold -s -w $(tput cols)
echo ""
if [ "$skip_panel_setup" = "false" ]; then
	if [ "$set_docklike" = "true" ]; then
		echo "- DO NOT TOUCH THE DOCKLIKE PLUGIN! It will look better after reboot"
	fi
	if [ "$desktop_button" = "1" ]; then
		echo "- DO NOT TOUCH THE GENMON PLUGIN! It will look better after reboot"
	fi
	echo "- Set the clock format to your country standard"
	echo "If you have a battery, change the following:"
	echo "- Power Manager > System > Critical Battery Power Level = 20"
	echo "-                        > System tray icon = Enabled"
fi
if [ "$detected_qubes_dom" = "true" ]; then
	echo -e "If you use Qubes OS, do the following:"
	echo -e "- Install Fake10 in the VMs (setting accent colors is recommended, skip the taskbar/panel stuff)" | fold -s -w $(tput cols)
	if [ "$theme" = "1" ]; then
		echo -e "- For sys-net, change the VM color to gray and overwrite the icons in ~/.icons/Fake10/16/ with icons from ./Qubes/Dark Icons/Network Manager/" | fold -s -w $(tput cols)
	else
		echo -e "- For sys-net, change the VM color to gray and overwrite the icons in ~/.icons/Fake10/16/ with icons from ./Qubes/Light Icons/Network Manager/" | fold -s -w $(tput cols)
	fi
	echo -e "- For whonix-gateway, run \" qvm-run -u root whonix-gateway-18 'pcmanfm-qt' \" to open a file explorer in root" | fold -s -w $(tput cols)
	if [ "$theme" = "1" ]; then
		echo -e "- Copy the sdwdate icons from ./Qubes/Dark Icons/ to the Whonix Gateway VM and overwrite the old icons in /usr/share/sdwdate-gui/icons/" | fold -s -w $(tput cols)
	else
		echo -e "- Copy the sdwdate icons from ./Qubes/Light Icons/ to the Whonix Gateway VM and overwrite the old icons in /usr/share/sdwdate-gui/icons/" | fold -s -w $(tput cols)

	fi
	echo -e "- Back up and overwrite the Adwaita cursors in /usr/share/icons/Adwaita/cursors/ with your desired cursors" | fold -s -w $(tput cols)
fi
if [ "$detected_qubes_dom" = "false" ]; then
	echo "If you use Firefox, do the following:"
	if [ "$theme" = "1" ]; then
		echo "- Firefox > Settings > Extensions & Themes > Dark = Enabled"
	else
		echo "- Firefox > Settings > Extensions & Themes > Light = Enabled"
	fi
	if [ "$detected_qubes_vm" = "true" ]; then
		echo "-         > Customize Toolbar > Title Bar = Enabled"
	fi
	echo "-         > about:config > toolkit.legacyUserProfileCustomizations.stylesheets = true"
	echo "-                        > widget.gtk.overlay-scrollbars.enabled = false"
	echo "-                        > widget.non-native-theme.gtk.scrollbar.allow-buttons = true"
	echo "-                        > widget.non-native-theme.gtk.scrollbar.round-thumb = false"
	echo "-                        > widget.non-native-theme.scrollbar.style = 4"
	echo "-                        > widget.non-native-theme.scrollbar.size.override = 17"
	echo "-                        > layout.css.scrollbar-width-thin.disabled = true"
	echo -e "- Find your Firefox profile directory path in about:support and create subdirectory \"chrome\" inside it" | fold -s -w $(tput cols)
	if [ "$theme" = "1" ]; then
		echo -e "- Move userChrome.css from ./Firefox/Dark Theme/ to the chrome directory you just made" | fold -s -w $(tput cols)
	else
		echo -e "- Move userChrome.css from ./Firefox/Light Theme/ to the chrome directory you just made" | fold -s -w $(tput cols)
	fi
fi
echo ""
echo "Press any key after completing steps above..."
read -n 1 -s -r
echo ""
echo "ALL DONE!"
echo -e "You can now reboot your system to fix fonts, scrollbars, alignment, etc." | fold -s -w $(tput cols)
echo ""
if [ "$skip_panel_setup" = "false" ]; then
	read -p ":: Open bundled Windows wallpaper folder? [y/N] " answer
	case $answer in
		[Yy] )
			echo "Opening.."
			xdg-open ./Wallpaper/
		;;
		* ) ;;
	esac
	echo ""
fi
if [ "$detected_qubes_vm" = "true" ]; then
	read -p ":: Shut down system? [y/N] " answer
else
	read -p ":: Reboot system? [y/N] " answer
fi
case $answer in
	[Yy] ) systemctl reboot ;;
	* ) ;;
esac
echo ""