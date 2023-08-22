{
  description = "Sylvain's home manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = {home-manager,nixpkgs,nixgl,...}:let
    mkFeatures = {
      gui ? false,
      devtools ? false,
      intel ? false,
      nvidia ? false,
    }@x: x;
    mkHomeManagerConf = features: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ nixgl.overlay ];
        };
        extraSpecialArgs = mkFeatures features;
        modules = [ ./home.nix ];
      };
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    homeConfigurations = {
      "sylvain@hyperion" = mkHomeManagerConf {gui=true;intel=true;};
      "sylvain@titan" = mkHomeManagerConf {gui=true;nvidia=true;devtools=true;};
      "sylvain@lscarisey" = mkHomeManagerConf {gui=true;intel=true;devtools=true;nvidia=false;};
    };
  };
}
