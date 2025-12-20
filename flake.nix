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
  outputs = inputs@{ nixpkgs, home-manager, ... }: {
    nixosConfigurations = {
      repti = nixpkgs.lib.nixosSystem {
        system = "x86_64";
        modules = [
          ./repti/configuration.nix
          home-manager.nixosModules.home-manager {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;
            home-manager.users.asd = ./repti/asd/home-configuration.nix;
            home-manager.users.qed = ./repti/qed/home-configuration.nix;
            home-manager.users.sk4zuzu = ./repti/sk4zuzu/home-configuration.nix;
          }
        ];
      };
      x1a1 = nixpkgs.lib.nixosSystem {
        system = "x86_64";
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
