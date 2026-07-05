#!/bin/bash 

	echo "---> Iniciando processos de pós-instalação... <---"
	
	pacs="obs-studio.x86_64   gimp.x86_64   ranger.x86_64   syncthing.x86_64   kdenlive.x86_64   htop.x86_64   vlc.x86_64   gparted.x86_64   fastfetch.x86_64   flatpak.x86_64   xfce4-clipman.x86_64   xfce4-screenshooter.x86_64   xfce4-notes.x86_64   firefox.x86_64   audacity.x86_64    imagemagick.x86_64   kolourpaint.x86_64   qbittorrent.x86_64   mousepad.x86_64   thunderbird.x86_64   chromium.x86_64  "
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
    com.brave.Browser
	"
	sudo dnf install https://mirrors.rpmfusion.org/free/fedora/rpmfusion-free-release-$(rpm -E %fedora).noarch.rpm https://mirrors.rpmfusion.org/nonfree/fedora/rpmfusion-nonfree-release-$(rpm -E %fedora).noarch.rpm

	# Corrigir os problemas de codec
	sudo dnf swap ffmpeg-free ffmpeg --allowerasing -y
	sudo dnf install amrnb amrwb faad2 flac gpac-libs lame libde265 libfc14audiodecoder mencoder x264 x265 ffmpegthumbnailer -y
	
	#Atualizar repositórios
	sudo dnf upgrade -y
	
	#Adicionar repositório flatpak
	flatpak remote-add --if-not-exists flathub https://dl.flathub.org/repo/flathub.flatpakrepo
	
	#Instalação paralelar de dnf e flatpak
	sudo dnf install -y $pacs &
	flatpak install --user -y flathub $flat &
	
	wait
	
	#limpeza automática
	sudo dnf autoremove -y
	
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
