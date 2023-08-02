{
  description = "NixOS configuration of Jon Whittlestone";

    nixConfig = {
        experimental-features = [ "nix-command" "flakes" ];
        substituters = [
        # replace official cache with a mirror located in China
        "https://mirrors.bfsu.edu.cn/nix-channels/store"
        "https://cache.nixos.org/"
        ];

        # nix community's cache server
        extra-substituters = [
        "https://nix-community.cachix.org"
        ];
        extra-trusted-public-keys = [
        "nix-community.cachix.org-1:mB9FSh9qf2dCimDSUo8Zy7bkq5CX+/rkCWyvRCYg3Fs="
        ];
    };
  inputs = {
    nixpkgs.url = "github:nixos/nixpkgs/nixos-unstable";      # 使用 nixos-unstable 分支
    home-manager.url = "github:nix-community/home-manager";
    home-manager.inputs.nixpkgs.follows = "nixpkgs";

  };
  outputs = inputs@{
      self,
      nixpkgs,
      home-manager,
      ...
  }: {
    nixosConfigurations = {
      doylestone06 = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";

        modules = [
          ./hosts/doylestone06
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.jon = import ./home;
          }
        ];
      };

    };
  };
}
