{
  description = "Sylvain's home manager";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixpkgs-unstable";
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";
    nixgl.url = "github:guibou/nixGL";
  };

  outputs = {home-manager,nixpkgs,nixgl,...}:let
    mkHomeManagerConf = {withGUI ? false,withIntel ? false}: home-manager.lib.homeManagerConfiguration {
        pkgs = import nixpkgs {
          system = "x86_64-linux";
          overlays = [ nixgl.overlay ];
        };
        extraSpecialArgs = { inherit withGUI withIntel; };
        modules = [ ./home.nix ];
      };
  in {
    defaultPackage.x86_64-linux = home-manager.defaultPackage.x86_64-linux;
    homeConfigurations = {
      "sylvain" = mkHomeManagerConf {};
      "sylvain@lscarisey" = mkHomeManagerConf { withGUI=true;withIntel=true;};
    };
  };
}
