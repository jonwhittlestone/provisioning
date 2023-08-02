{ config, pkgs, ... }:

{
    imports = [
        ../../modules/system.nix
        # ../../modules/common.nix

        # Include the results of the hardware scan.
        ./hardware-configuration.nix
    ];

    # Bootloader.
    boot.loader.systemd-boot.enable = true;
    boot.loader.efi.canTouchEfiVariables = true;

    networking.hostName = "doylestone03"; # Define your hostname.

    # Enable networking
    networking.networkmanager.enable = true;

    system.stateVersion = "23.05"; # Did you read the comment?
}