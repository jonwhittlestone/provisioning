# Guide: Setting up a git managed Flake on NixOS from scratch

This is a guide for transitioning from a fresh NixOS install to using a flake / home-manager repo like this.

> https://github.com/jonwhittlestone/provisioning

## Resources

We lift from the NixOS and Flakes book heavily.

https://nixos-and-flakes.thiscute.world/

## Prerequisites

- Ability to create a bootable SD card containing Write the NixOS iso using [https://etcher.balena.io/](etcher) or [https://rufus.ie/en/])rufus)

## 0. Dual boot [optional]

I wanted to dual boot with Windows so I can run Ableton.

In this case, I first installed Windows 11 iso and completed all OS updates.

> https://nixos-and-flakes.thiscute.world/

And then installed NixOS with a bootable USB.

## 1. Fresh install -> getting essential packages

Try a sanity check build that installs vim with:

> Note we set the `hostName` below as `doylestone03`. You will want to set your own host name.

```nix
# /etc/nixos/configuration.nix

...
networking.hostName = "doylestone03";
...

users.users.jon = {
  isNormalUser = true;
  description = "Jon Whittlestone";
  extraGroups = [ "networkmanager" "wheel" ];

  packages = with pkgs; [
    vim
  ];
};
```

```bash
sudo nano /etc/nixos/configuration.nix;
sudo nixos-rebuild switch
```

> Start a new bash session to reflect your hostname changes
>
> eg.
>
> ```bash
> [jon@doylestone03:/etc/nixos]
> ```

## 2. Installing Flakes

As [per the NixOS book](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/nixos-with-flakes-enabled#switching-to-flake-nix-for-system-configuration), enable Flakes Support

```nix
# /etc/nixos/configuration.nix
{ config, pkgs, ... }:

{
  imports =
    [ # Include the results of the hardware scan.
      ./hardware-configuration.nix
    ];

  nix.settings.experimental-features = [ "nix-command" "flakes" ];

  environment.systemPackages = with pkgs; [
    # Flakes use Git to pull dependencies from data sources, so Git must be installed first
    git
    vim
    wget
    curl
  ];

...
}

```

And then deploy again:

```bash
sudo nixos-rebuild switch
```

Then create a flake.nix file:

```bash
# ensure you're in cd /etc/nixos;

sudo nix flake init -t templates#full

```

Add a basic example `flake.nix`.

All system modifications will now be managed by Flakes.

> The example below has the hostname: `doylestone03` and you will want to use your own hostname.

```nix
# /etc/nixos/flake.nix
{
  description = "Jon's NixOS Flake";

  inputs = {
    nixpkgs.url = "github:NixOS/nixpkgs/nixos-unstable";
    # home-manager, used for managing user configuration
    home-manager = {
      url = "github:nix-community/home-manager/release-23.05";
      inputs.nixpkgs.follows = "nixpkgs";
    };
  };

  outputs = { self, nixpkgs, ... }@inputs: {
    nixosConfigurations = {
      # deploy this configuration on any NixOS system:
      #   sudo nixos-rebuild switch --flake .#doylestone03
      "doylestone03" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./configuration.nix
        ];
      };
    };
  };
}

```

Run: `sudo nixos-rebuild swtich` to deploy.

## 3. Installing/Using home-manager

Because NixOS can only manage system-level configuration, we need to install Home Manager to manage user-level config.

Install Home Manager as a NixOS module by creating `/etc/nixos/home.nix` and then adjust the params of `/etc/nixos/flake.nix`

```nix
# /etc/nixos/home.nix
{ config, pkgs, ... }:

{
  home.username = "jon";
  home.homeDirectory = "/home/jon";

  xresources.properties = {
    "Xcursor.size" = 16;
    "Xft.dpi" = 172;
  };

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Jon Whittlestone";
    userEmail = "dev@howapped.com";
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    btop  # replacement of htop/nmon
  ];


  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      nixd = "sudo nixos-rebuild switch";
    };
  };

  home.stateVersion = "23.05";

  programs.home-manager.enable = true;
}


```

```nix

...

outputs = inputs@{ nixpkgs, home-manager, ... }: {
      nixosConfigurations = {
        doylestone03 = nixpkgs.lib.nixosSystem {
	  system = "x86_64-linux";
	  modules = [
	    ./configuration.nix

	    # make home-manager as a module of nixos
	    # so that home-manager configuration will be deployed automatically when executing `nixos-rebuild switch`
	    home-manager.nixosModules.home-manager
	    {
	      home-manager.useGlobalPkgs = true;
	      home-manager.useUserPackages = true;

	      home-manager.users.jon = import ./home.nix;

	      # Optionally, use home-manager.extraSpecialArgs to pass arguments to home.nix
	    }
	  ];
        };
      };
    };


```

## 4. Create symlink manage with git

As per the [git section](https://nixos-and-flakes.thiscute.world/nixos-with-flakes/other-useful-tips#managing-the-configuration-with-git), you can place your flake in a version controlled local directory and create a symbolic link:

```nix
sudo mv /etc/nixos /etc/nixos.bak  # Backup the original configuration
sudo ln -s ~/code/provisioning/ /etc/nixos

# Deploy the flake.nix located at the default location (/etc/nixos)
sudo nixos-rebuild switch
```

<!--
## 5. Modularising with `imports`

We now have the following files.

```bash

 ❯ tree nixos-config/
nixos-config/
├── configuration.nix
├── flake.lock
├── flake.nix
├── hardware-configuration.nix
├── home.nix
└── Makefile

1 directory, 6 files

```

For easier maintenance of these files, we can use the Nix module system to split the configuration into multiple Nix modules.

Using [this modular file system as an example](https://github.com/jonwhittlestone/my-fork-of-ryans-nix-config/tree/v0.0.2), amend the following files to create the following structure.

```bash
[jon@doylestone03:/etc/nixos]$ tree
.
├── configuration.nix
├── flake.lock
├── flake.nix
├── home
│   ├── common.nix
│   └── default.nix
├── hosts
│   └── doylestone03
│       ├── default.nix
│       └── hardware-configuration.nix
└── modules
    └── system.nix

7 directories, 6 files

```


```nix
# /etc/nixos/flake.nix

{
  description = "Jon's NixOS Flake";

  ...

  outputs = {
    self,
    nixpkgs,
    home-manager,
    ...

  }@inputs: {
    nixosConfigurations = {
      # deploy this configuration on any NixOS system:
      #   sudo nixos-rebuild switch --flake .#doylestone03
      "doylestone03" = nixpkgs.lib.nixosSystem {
        system = "x86_64-linux";
        modules = [
          ./hosts/doylestone03
          home-manager.nixosModules.home-manager
          {
            home-manager.useGlobalPkgs = true;
            home-manager.useUserPackages = true;

            home-manager.extraSpecialArgs = inputs;
            home-manager.users.ryan = import ./home;
          }
        ];
      };
    };
  };
}

```

```nix
# /etc/nixos/home/default.nix



```
-->
