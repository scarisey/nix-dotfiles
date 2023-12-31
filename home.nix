{pkgs,lib,config,intel,nvidia,...}:{ 
  nixpkgs.config.allowUnfreePredicate = (pkg: true);
  programs.home-manager.enable = true;
  home.username = "sylvain";
  home.homeDirectory = "/home/sylvain";
  home.stateVersion = "23.05";
  targets.genericLinux.enable = true;
  fonts.fontconfig.enable = true;
  home.packages = with pkgs; [
    (nerdfonts.override { fonts = [ "FiraCode" "FiraMono" "DroidSansMono" "Hack" "Hasklig" "Meslo" "UbuntuMono" ]; })

    git
    git-lfs
    curl
    dos2unix
    screen
    ranger
    thefuck
    peco #querying input
    fd #better find
    bat
    exa
    jq
    yq
    neovim
    nil #  nix LSP
    ripgrep #recursive search fs for a regex
    w3m
    lazygit
    ghq
    btop
    powertop
    poppler_utils #pdf conversions
    ttygif
    gifsicle
    rclone
    cryfs
    cht-sh
    perl536Packages.EmailOutlookMessage

  ] 
  ++ lib.optionals intel [
    nixgl.nixGLIntel
  ]
  ++ lib.optionals nvidia [
    nixgl.auto.nixGLNvidia
  ];

  home.sessionVariables = {
    GITDIR = "$HOME/git";
    EDITOR = "vim";
  };


  home.shellAliases = {
    dotfiles="git --git-dir $GITDIR/dotfiles/ --work-tree=$HOME";
    initDotfiles="f(){ mkdir -p $GITDIR || true; git clone --bare $1 $GITDIR/dotfiles; dotfiles config status.showUntrackedFiles no; }; f";
    vi = "nvim";
    #exa
    ll="exa --long --header";
    la="exa --long --all --header";
    lt="exa -T -L=2";

    #tmux
    ta="tmux attach-session";
    tm="tmux new-session -t $(basename $(pwd))";

    #sbt
    sbtc="sbt --client";

    #cheat.sh
    cht="cht.sh";

  };

  programs.zsh = {
    #https://rycee.gitlab.io/home-manager/options.html#opt-programs.zsh.enable
    enable = true;
    enableCompletion = true;
    enableAutosuggestions = true;
    initExtra = ''
    eval $(thefuck --alias)
    source $HOME/.customzsh.rc &> /dev/null|| true 
    '';

    history = {
      share = true; # false -> every terminal has it's own history
        size = 9999999; # Number of history lines to keep.
        save = 9999999; # Number of history lines to save.
        ignoreDups = true; # Do not enter command lines into the history list if they are duplicates of the previous event.
        extended = true; # Save timestamp into the history file.
    };
    oh-my-zsh = {
      enable = true;
      plugins = [
        "git"
        "docker"
        "docker-compose"
        "kubectl"
        "helm"
        "sbt"
        "bgnotify"
        "fzf"
        "zsh-interactive-cd"
        "z"
      ];

    };

  };
  programs.starship = {
    enable = true;
    enableZshIntegration = true;

  };
  programs.fzf = {
    enable=true;
    enableZshIntegration=true;
  };
  programs.direnv = {
    enable = true;
    nix-direnv.enable = true;
    enableZshIntegration = true;
  };
  programs.tmux = {
    enable = true;
    prefix = "C-a";
    terminal = "screen-256color";
    clock24 = true;
    customPaneNavigationAndResize = true;
    escapeTime = 10;
    historyLimit = 100000;
    mouse = true;
    extraConfig = ''
      source-file "$HOME/.gruvbox.tmuxtheme"
      # vim-like pane resizing  
      bind -r C-k resize-pane -U
      bind -r C-j resize-pane -D
      bind -r C-h resize-pane -L
      bind -r C-l resize-pane -R
      # vim-like pane switching
      bind -r k select-pane -U 
      bind -r j select-pane -D 
      bind -r h select-pane -L 
      bind -r l select-pane -R 

      #vi selection mode
      setw -g mode-keys vi
      set-option -g status-interval 5
      set-option -g automatic-rename on
      set-option -g automatic-rename-format '#{b:pane_current_path}'
    '';
  };
  programs.vim = {
    enable = true;
    plugins = with pkgs.vimPlugins; [ vim-airline vim-airline-themes dracula-vim vim-surround ];
    extraConfig = "${ builtins.readFile ./vim/vimrc }";
  };

  home.file.".gruvbox.tmuxtheme" = {
    source = ./tmux/gruvbox.tmuxtheme;
  };
  home.file.".config/ranger/rc.conf" = {
    source = ./ranger/rc.conf;
  };

}
