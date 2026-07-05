#!/bin/bash 

	echo "---> Iniciando processos de pós-instalação... <---"
	
	pacs="obs-studio   gimp   ranger   syncthing   kdenlive   htop   vlc   gparted   fastfetch   flatpak   xfce4-clipman   xfce4-screenshooter   xfce4-notes   firefox-esr   audacity    imagemagick   kolourpaint   qbittorrent   mousepad   thunderbird   chromium  "
	flat="
    com.protonvpn.www    
    md.obsidian.Obsidian       
	com.wps.Office 
    com.usebottles.bottles 
    com.rtosta.zapzap 
    com.markopejic.downloader 
    com.github.phase1geo.minder 
    com.vscodium.codium 
    com.dec05eba.gpu_screen_recorder 
    no.mifi.losslesscut 
    com.rafaelmardojai.Blanket 
    net.waterfox.waterfox 
    com.github.tchx84.Flatseal  
    net.sourceforge.osmo  
    com.dec05eba.gpu_screen_recorder      
    com.brave.Browser
	"
	sudo apt update -y &&  sudo apt upgrade -y
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	sudo apt install -y $pacs &
	flatpak install --user -y flathub $flat &
	wait
	
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
