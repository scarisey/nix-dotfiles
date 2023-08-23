{pkgs,lib,config,gui,...}: lib.mkIf gui { 
  home.packages = with pkgs; [
    quickemu
    quickgui

    alacritty
    conky

    timeshift
    xclip
    pavucontrol
    flameshot

    jetbrains.idea-community
  ];
}
