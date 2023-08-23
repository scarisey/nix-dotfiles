{pkgs,lib,config,gui,devtools,...}: let
    npmGlobalDir = "$HOME/.npm-global";
in lib.mkIf devtools { 
  home.packages = with pkgs; [
    #c
    gcc
    #lua
    lua
    luarocks
    #jvm
    temurin-bin-17
    sbt
    scala-cli
    coursier
    maven
    gradle
    #others
    nodejs
    cargo
  ]
  ++ lib.optionals gui [
    jetbrains.idea-community
  ];

  home.activation.npmSetPrefix = lib.hm.dag.entryAfter [ "reloadSystemd" ] "$DRY_RUN_CMD ${config.home.path}/bin/npm $VERBOSE_ARG set prefix ${npmGlobalDir}"; #then npm -g install should work
}
