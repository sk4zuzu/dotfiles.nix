{
  inputs = {
    nixpkgs = {
      url = "github:nixos/nixpkgs/nixos-unstable";
    };
    home-manager = {
      url = "github:nix-community/home-manager";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };
  outputs = { nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      repti = nixpkgs.lib.nixosSystem {
        modules = [
          ./repti/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.asd = ./repti/asd/home-configuration.nix;
            home-manager.users.ead = ./repti/ead/home-configuration.nix;
            home-manager.users.sk4zuzu = ./repti/sk4zuzu/home-configuration.nix;
          }
        ];
      };
      x1a1 = nixpkgs.lib.nixosSystem {
        modules = [
          ./x1a1/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.asd = ./x1a1/asd/home-configuration.nix;
          }
        ];
      };
    };
  };
}
