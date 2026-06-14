#!/bin/bash 

#Instalação de programas
echo "---> Iniciando processos de pós-instalação... <---"

sudo apt update -y
sudo apt upgrade -y

sudo apt install curl -y
curl -fsS https://dl.brave.com/install.sh | sh

sudo apt install thunar tumbler thunar-archive-plugin thunar-media-tags-plugin gvfs -y
sudo apt install obs-studio -y
sudo apt install gimp -y
sudo apt install ranger -y
sudo apt install kate -y
sudo apt install nano -y
sudo apt install syncthing -y
sudo apt install kdenlive -y
sudo apt install htop -y
sudo apt install vlc -y
sudo apt install gparted -y
sudo apt install gwenview -y
sudo apt install fastfetch -y
sudo apt install xfce4-terminal -y
sudo apt install flatpak -y
sudo apt install mate-power-manager -y
sudo apt install xfce4-clipman -y
sudo apt install libreoffice -y
sudo apt install xfce4-screenshooter -y
sudo apt install xfce4-notes -y
sudo apt install firefox-esr -y
sudo apt install audacity -y
sudo apt install gnome-calculator -y
sudo apt install imagemagick -y
sudo apt innstall kolourpaint -y
sudo apt install qbittorrent -y
sudo apt install mousepad -y
sudo apt install conky-all -y

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y com.protonvpn.www   
flatpak install -y md.obsidian.Obsidian      
flathub install -y org.onlyoffice.desktopeditors
flatpak install -y flathub com.usebottles.bottles
flatpak install -y com.rtosta.zapzap
flatpak install -y com.markopejic.downloader
flatpak install -y com.github.phase1geo.minder
flatpak install -y com.vscodium.codium
flatpak install -y com.dec05eba.gpu_screen_recorder
flatpak install -y no.mifi.losslesscut
flatpak install -y com.rafaelmardojai.Blanket

echo -e "\n"
cat << "EOF"
 #####    #  #    ###    ######     ######    #     #   #          #   #      #   #      #    #       #
#     #   #  #    ###   #      #   #      #   #     #   #              ##     #   #      #     #     #
#     #   #  #    ###   #      #   #      #   #     #   #              # #    #   #      #      #   #
######     #            #      #   #      #   #     #   #          #   #  #   #   #      #       # #
#     #    #            #######    ########   #     #   #          #   #   #  #   #      #        #
#      #   #      ###   #          #      #   #     #   #          #   #    # #   #      #      #   #
#      #   #      ###   #          #      #   #     #   #          #   #     ##   #      #    #      #
#######    #      ###   #          #      #    #####    ########   #   #      #    ######    #        #
EOF
echo -e "\n"





