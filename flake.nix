{
  description = "Sylvain's home manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = {home-manager,nixpkgs,nixgl,...}:let
    mkFeatures = xs: nixpkgs.lib.fold (x: z: z // { ${x}=true; } ) {gui=false;devtools=false;intel=false;nvidia=false;} xs;
    mkHomeManagerConf = features: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ nixgl.overlay ];
        };
        extraSpecialArgs = mkFeatures features;
        modules = [ ./home.nix ./gui.nix ./devtools.nix ];
      };
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    homeConfigurations = {
      "sylvain@hyperion" = mkHomeManagerConf [ "gui" "intel" ];
      "sylvain@titan" = mkHomeManagerConf [ "gui" "nvidia" "devtools" ];
      "sylvain@lscarisey" = mkHomeManagerConf [ "gui" "intel" "devtools" ];
    };
  };
}
