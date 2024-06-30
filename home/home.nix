{
  config,
  pkgs,
  inputs,
  ...
}: {
  imports = [
    inputs.hyprland.homeManagerModules.default
    ./programs/nvim.nix
    ./programs/hyprland.nix
    ./programs/obs.nix
    ./programs/dunst.nix
    ./programs/starship.nix
    ./programs/fish.nix
    ./programs/kitty.nix
    ./programs/rofi.nix
    ./programs/waybar.nix
    ./programs/btop.nix
  ];
  home = {
    username = "jacob";
    homeDirectory = "/home/jacob";
    sessionVariables = {
      HOME_NIX = "$HOME/.config/nixos/home/home.nix";
      SYS_NIX = "$HOME/.config/nixos/system/configuration.nix";
    };
    packages = with pkgs; [
      firefox-devedition
      spotify
      bitwarden
      pcmanfm
      wineWowPackages.stable
      winetricks
      lutris
      playerctl
      cliphist
      wl-clipboard
      helvum
      lutris
      obsidian-wayland
      swww
      insomnia
      ripgrep
      inotify-tools
      jetbrains.datagrip
      element-desktop
      ngrok
      gh
      gimp
      arduino
      fd
      orca-slicer
      ollama
      calibre
      erlang-ls
      qbittorrent
      mpv
      google-chrome
      lexical
      inputs.hyprland-contrib.packages.${pkgs.system}.grimblast
    ];
  };
  programs.home-manager.enable = true;
  programs.direnv = {
    enable = true;
    config = {
      global = {
        load_dotenv = true;
      };
    };
    nix-direnv = {
      enable = true;
    };
  };
  systemd.user.startServices = "sd-switch";
  programs.git = {
    enable = true;
    userName = "Leastrio";
    userEmail = "jacob@leastr.io";
    extraConfig.init.defaultBranch = "main";
    extraConfig.credential.helper = "store";
    extraConfig.push.autoSetupRemote = true;
  };
  home.stateVersion = "23.05";
}
