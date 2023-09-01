{pkgs,lib,config,gui,devtools,...}: let
    npmGlobalDir = "$HOME/.npm-global";
in lib.mkIf devtools { 
  home.packages = with pkgs; [
    #c
    gcc
    glibc
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

  home.sessionVariables = lib.mkAfter {
    JAVA_HOME = "${pkgs.temurin-bin-17}";
  };

  home.activation.npmSetPrefix = lib.hm.dag.entryAfter [ "reloadSystemd" ] "$DRY_RUN_CMD ${config.home.path}/bin/npm $VERBOSE_ARG set prefix ${npmGlobalDir}"; #then npm -g install should work
}
