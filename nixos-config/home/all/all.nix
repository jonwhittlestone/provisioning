{ config, pkgs, ... }:

{

  # basic configuration of git, please change to your own
  programs.git = {
    enable = true;
    userName = "Jon Whittlestone";
    userEmail = "dev@howapped.com";
  };

  programs.vscode = {
    enable = true;
    package = pkgs.vscode.fhs;
  };

  programs.gh = {
    enable = true;
  };

  # Packages that should be installed to the user profile.
  home.packages = with pkgs; [
    # here is some command line tools I use frequently
    # feel free to add your own or remove some of them

    #neofetch
    #nnn # terminal file manager

    # archives
    zip
    xz
    unzip
    p7zip

    # browsers
    google-chrome
    vivaldi
    brave

    # utils
    jq # A lightweight and flexible command-line JSON processor
    nmap # A utility for network discovery and security auditing
    ipcalc  # it is a calculator for the IPv4/v6 addresses

    # langs and runtimes
    python311
    poetry
    python311Packages.black               # python formatter
    python311Packages.ipython
    python311Packages.pip
    python311Packages.pipx
    python311Packages.flake8
    python311Packages.jupyterlab
    nodePackages.pyright                  # python language server
    
    nodejs
    nodePackages_latest.typescript
    nodePackages.npm
    nodePackages.pnpm
    yarn

    docker-compose
    gitkraken

    # misc
    variety			# wallpaper manager
    cowsay
    file
    which
    tree
    gnused
    gnutar
    gawk
    zstd
    gnupg
    gnomeExtensions.clipboard-indicator

    # misc
    flameshot         # run `flameshot gui`

    # messaging
    signal-desktop

    # media
    vlc


    # productivity
    glow # markdown previewer in terminal

    btop  # replacement of htop/nmon

    # system call monitoring
    strace # system call monitoring
    ltrace # library call monitoring
    lsof # list open files
  ];

  # starship - an customizable prompt for any shell
  programs.starship = {
    enable = true;
    # custom settings
    settings = {
      add_newline = false;
      aws.disabled = true;
      gcloud.disabled = true;
      line_break.disabled = true;
    };
  };

  # alacritty - a cross-platform, GPU-accelerated terminal emulator
  programs.alacritty = {
    enable = true;
    # custom settings
    settings = {
      env.TERM = "xterm-256color";
      font = {
        size = 12;
        draw_bold_text_with_bright_colors = true;
      };
      scrolling.multiplier = 5;
      selection.save_to_clipboard = true;
    };
  };

  programs.bash = {
    enable = true;
    enableCompletion = true;
    bashrcExtra = ''
      export PATH="$PATH:$HOME/bin:$HOME/.local/bin:$HOME/go/bin"
    '';

    # set some aliases, feel free to add more or remove some
    shellAliases = {
      k = "kubectl";
      urldecode = "python3 -c 'import sys, urllib.parse as ul; print(ul.unquote_plus(sys.stdin.read()))'";
      urlencode = "python3 -c 'import sys, urllib.parse as ul; print(ul.quote_plus(sys.stdin.read()))'";
      fl = "flameshot gui";
      prv = "code ~/code/provisioning-repos.code-workspace";
      # nixd = "cd ~/code/provisioning/nixos-config/ && make deploy && cd -";
    };
  };

  home.shellAliases = {
    fl = "flameshot gui";
    prv = "code ~/code/provisioning-repos.code-workspace";
    nixd = "cd ~/code/provisioning/nixos-config/ && make deploy && cd -";
  };

  # a cat(1) clone with syntax highlighting and Git integration.
  programs.bat = {
    enable = true;
    config = {
      pager = "less -FR";
    };
  };

  services = {
    flameshot.enable = true;
    flameshot.settings = {
      General = {
        disabledTrayIcon = true;
        showStartupLaunchMessage = false;
      };
    };
  };

}
