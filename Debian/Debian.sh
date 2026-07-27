#!/bin/bash

echo "---> Iniciando processos de pós-instalação... <---"

pacs="obs-studio
     gimp
     ranger
     syncthing
     kdenlive
     htop
     vlc
     gparted
     fastfetch
     flatpak
     xfce4-clipman
     xfce4-screenshooter
     xfce4-notes
     firefox-esr
     audacity
     imagemagick
     kolourpaint
     qbittorrent
     mousepad
     thunderbird
     chromium  
     geany
     astyle"


     flatpak install  -y   com.protonvpn.www
     flatpak install  -y   md.obsidian.Obsidian
     flatpak install  -y   com.wps.Office
#com.usebottles.bottles
     flatpak install  -y  com.rtosta.zapzap
     flatpak install  -y   com.markopejic.downloader
     flatpak install  -y    com.github.phase1geo.minder
     flatpak install  -y    com.vscodium.codium
     flatpak install  -y    com.dec05eba.gpu_screen_recorder
     flatpak install  -y   no.mifi.losslesscut
     flatpak install  -y   com.rafaelmardojai.Blanket
     flatpak install  -y   net.waterfox.waterfox
     flatpak install  -y    com.github.tchx84.Flatseal
#net.sourceforge.osmo
     flatpak install  -y  com.brave.Browser


#Atualizar repositórios
     sudo apt update -y &&  sudo apt upgrade -y

#Adicionar repositório flatpak
     flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo

#Instalação de apt 
     sudo apt install -y $pacs

  

#Limpeza
     sudo apt autoremove -y

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
