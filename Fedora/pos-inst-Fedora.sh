#!/bin/bash 

#Instalação de programas
echo "---> Iniciando processos de pós-instalação... <---"

sudo dnf update -y
sudo dnf upgrade -y

# Instalar o RPM Fusion
sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

# Corrigir os problemas de codec
sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
sudo dnf install amrnb amrwb faad2 flac gpac-libs lame libde265 libfc14audiodecoder mencoder x264 x265 ffmpegthumbnailer -y

sudo dnf install curl -y
curl -fsS https://dl.brave.com/install.sh | sh

sudo dnf install obs-studio.x86_64 -y
sudo dnf install gimp.x86_64 -y
sudo dnf install ranger.x86_64 -y
sudo dnf install syncthing.x86_64 -y
sudo dnf install kdenlive.x86_64 -y
sudo dnf install htop.x86_64 -y
sudo dnf install vlc.x86_64 -y
sudo dnf install gparted.x86_64 -y
sudo dnf install fastfetch.x86_64 -y
sudo dnf install flatpak.x86_64 -y
sudo dnf install xfce4-clipman.x86_64 -y
sudo dnf install xfce4-screenshooter.x86_64 -y
sudo dnf install xfce4-notes.x86_64 -y
sudo dnf install firefox.x86_64 -y
sudo dnf install audacity.x86_64 -y
sudo dnf install imagemagick.x86_64 -y
sudo dnf install kolourpaint.x86_64 -y
sudo dnf install qbittorrent.x86_64 -y
sudo dnf install mousepad.x86_64 -y
sudo dnf install thunderbird.x86_64 -y
sudo dnf install -y chromium.x86_64
sudo dnf install -y handbreak.x86_64

flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

flatpak install -y com.protonvpn.www   
flatpak install -y md.obsidian.Obsidian      
flathub install -y com.wps.Office
flatpak install -y flathub com.usebottles.bottles
flatpak install -y com.rtosta.zapzap
flatpak install -y com.markopejic.downloader
flatpak install -y com.github.phase1geo.minder
flatpak install -y com.vscodium.codium
flatpak install -y com.dec05eba.gpu_screen_recorder
flatpak install -y no.mifi.losslesscut
flatpak install -y com.rafaelmardojai.Blanket
flatpak install -y net.waterfox.waterfox
flatpak install -y com.github.tchx84.Flatseal 
flatpak install -y net.sourceforge.osmo  
flatpak install -y com.dec05eba.gpu_screen_recorder      


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





